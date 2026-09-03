import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:charset/charset.dart' as charset;
import 'package:crypto/crypto.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:markdown/markdown.dart' as markdown;
import 'package:path/path.dart' as path;
import 'package:pdfrx/pdfrx.dart';
import 'package:xml/xml.dart';

import '../../data/models/data_bank.dart';

enum DataBankDocumentFormat { plainText, markdown, html, pdf, epub }

enum DataBankChunkingStrategy { fixedLength, paragraph, chapter }

enum DataBankIngestionPhase { staging, parsing, chunking, completed }

enum DataBankIngestionFailureCode {
  sourceNotFound,
  unsupportedFormat,
  invalidEncoding,
  encryptedDocument,
  corruptDocument,
  emptyDocument,
  cancelled,
  ioFailure,
}

enum DataBankContentComparison { identical, changed }

final class DataBankIngestionException implements Exception {
  final DataBankIngestionFailureCode code;
  final String message;
  final Object? cause;

  const DataBankIngestionException(this.code, this.message, {this.cause});

  @override
  String toString() => 'DataBankIngestionException(${code.name}): $message';
}

final class DataBankCancellationToken {
  bool _cancelled = false;

  bool get isCancelled => _cancelled;

  void cancel() {
    _cancelled = true;
  }

  void throwIfCancelled() {
    if (_cancelled) {
      throw const DataBankIngestionException(
        DataBankIngestionFailureCode.cancelled,
        'Document ingestion was cancelled.',
      );
    }
  }
}

final class DataBankIngestionProgress {
  final DataBankIngestionPhase phase;
  final int completedUnits;
  final int totalUnits;

  const DataBankIngestionProgress({
    required this.phase,
    required this.completedUnits,
    required this.totalUnits,
  });

  double get fraction {
    if (totalUnits <= 0) return 0;
    return (completedUnits / totalUnits).clamp(0, 1).toDouble();
  }
}

typedef DataBankProgressCallback = void Function(
  DataBankIngestionProgress progress,
);

final class DataBankChunkingOptions {
  final DataBankChunkingStrategy strategy;
  final int maxCharacters;

  factory DataBankChunkingOptions({
    DataBankChunkingStrategy strategy = DataBankChunkingStrategy.paragraph,
    int maxCharacters = 1200,
  }) {
    if (maxCharacters < 1) {
      throw ArgumentError.value(
        maxCharacters,
        'maxCharacters',
        'must be at least 1',
      );
    }
    return DataBankChunkingOptions._(strategy, maxCharacters);
  }

  const DataBankChunkingOptions._(this.strategy, this.maxCharacters);
}

final class DataBankIngestionRequest {
  final File sourceFile;
  final String documentVersionId;
  final String? mediaType;
  final DataBankChunkingOptions chunking;
  final DataBankCancellationToken cancellationToken;
  final DataBankProgressCallback? onProgress;

  DataBankIngestionRequest({
    required this.sourceFile,
    required this.documentVersionId,
    this.mediaType,
    DataBankChunkingOptions? chunking,
    DataBankCancellationToken? cancellationToken,
    this.onProgress,
  })  : chunking = chunking ?? DataBankChunkingOptions(),
        cancellationToken = cancellationToken ?? DataBankCancellationToken() {
    if (documentVersionId.trim().isEmpty) {
      throw ArgumentError.value(
        documentVersionId,
        'documentVersionId',
        'must not be blank',
      );
    }
  }
}

final class DataBankIngestionResult {
  final String originalFileName;
  final String mediaType;
  final int byteSize;
  final DataBankContentHash contentHash;
  final String normalizedText;
  final String? detectedEncoding;
  final List<DataBankSection> sections;
  final List<DataBankTextChunk> chunks;

  const DataBankIngestionResult({
    required this.originalFileName,
    required this.mediaType,
    required this.byteSize,
    required this.contentHash,
    required this.normalizedText,
    required this.detectedEncoding,
    required this.sections,
    required this.chunks,
  });

  DataBankContentComparison compareContent(
    DataBankContentHash previousContentHash,
  ) {
    return previousContentHash.algorithm == contentHash.algorithm &&
            previousContentHash.digest == contentHash.digest
        ? DataBankContentComparison.identical
        : DataBankContentComparison.changed;
  }
}

final class DataBankPdfPage {
  final int pageNumber;
  final String text;

  const DataBankPdfPage({required this.pageNumber, required this.text});
}

abstract interface class DataBankPdfTextExtractor {
  Future<List<DataBankPdfPage>> extractPages(
    File file, {
    required DataBankCancellationToken cancellationToken,
    required void Function(int completedPages, int totalPages) onProgress,
  });
}

final class PdfrxDataBankPdfTextExtractor implements DataBankPdfTextExtractor {
  const PdfrxDataBankPdfTextExtractor();

  @override
  Future<List<DataBankPdfPage>> extractPages(
    File file, {
    required DataBankCancellationToken cancellationToken,
    required void Function(int completedPages, int totalPages) onProgress,
  }) async {
    PdfDocument? document;
    try {
      cancellationToken.throwIfCancelled();
      document = await PdfDocument.openFile(file.path);
      if (document.isEncrypted) {
        throw const DataBankIngestionException(
          DataBankIngestionFailureCode.encryptedDocument,
          'Encrypted PDF documents are not supported.',
        );
      }

      final pages = <DataBankPdfPage>[];
      final totalPages = document.pages.length;
      for (var index = 0; index < totalPages; index++) {
        cancellationToken.throwIfCancelled();
        final pageText = await document.pages[index].loadText();
        cancellationToken.throwIfCancelled();
        pages.add(
          DataBankPdfPage(
            pageNumber: index + 1,
            text: pageText?.fullText ?? '',
          ),
        );
        onProgress(index + 1, totalPages);
      }
      return pages;
    } on PdfPasswordException catch (error) {
      throw DataBankIngestionException(
        DataBankIngestionFailureCode.encryptedDocument,
        'The PDF requires a password.',
        cause: error,
      );
    } on PdfException catch (error) {
      throw DataBankIngestionException(
        DataBankIngestionFailureCode.corruptDocument,
        'The PDF could not be parsed.',
        cause: error,
      );
    } finally {
      await document?.dispose();
    }
  }
}

typedef DataBankStagingDirectoryProvider = Future<Directory> Function();

final class DataBankIngestionService {
  final DataBankPdfTextExtractor _pdfTextExtractor;
  final DataBankStagingDirectoryProvider _createStagingDirectory;

  DataBankIngestionService({
    DataBankPdfTextExtractor pdfTextExtractor =
        const PdfrxDataBankPdfTextExtractor(),
    DataBankStagingDirectoryProvider? createStagingDirectory,
  })  : _pdfTextExtractor = pdfTextExtractor,
        _createStagingDirectory = createStagingDirectory ??
            (() => Directory.systemTemp.createTemp(
                  'native_tavern_data_bank_',
                ));

  Future<DataBankIngestionResult> ingest(
    DataBankIngestionRequest request,
  ) async {
    request.cancellationToken.throwIfCancelled();
    if (!request.sourceFile.existsSync()) {
      throw DataBankIngestionException(
        DataBankIngestionFailureCode.sourceNotFound,
        'Source file does not exist: ${request.sourceFile.path}',
      );
    }

    final sourceType = _resolveSourceType(
      request.sourceFile.path,
      request.mediaType,
    );
    Directory? stagingDirectory;
    try {
      stagingDirectory = await _createStagingDirectory();
      final stagedFile = File(
        path.join(
          stagingDirectory.path,
          'source${path.extension(request.sourceFile.path)}',
        ),
      );
      final staged = await _stageAndHash(request, stagedFile);
      request.cancellationToken.throwIfCancelled();

      final parsed = await _parse(
        stagedFile,
        sourceType,
        request,
      );
      request.cancellationToken.throwIfCancelled();
      final resolved = _resolveSegments(parsed.segments);
      if (resolved.isEmpty) {
        throw const DataBankIngestionException(
          DataBankIngestionFailureCode.emptyDocument,
          'The document contains no importable text.',
        );
      }

      final sections = _buildSections(
        request.documentVersionId,
        resolved,
      );
      final chunks = _buildChunks(
        request.documentVersionId,
        resolved,
        request.chunking,
        request,
      );
      if (chunks.isEmpty) {
        throw const DataBankIngestionException(
          DataBankIngestionFailureCode.emptyDocument,
          'The document contains no importable text.',
        );
      }

      _report(
        request,
        const DataBankIngestionProgress(
          phase: DataBankIngestionPhase.completed,
          completedUnits: 1,
          totalUnits: 1,
        ),
      );
      request.cancellationToken.throwIfCancelled();
      return DataBankIngestionResult(
        originalFileName: path.basename(request.sourceFile.path),
        mediaType: sourceType.mediaType,
        byteSize: staged.byteSize,
        contentHash: DataBankContentHash(
          algorithm: DataBankHashAlgorithm.sha256,
          digest: staged.digest,
        ),
        normalizedText: resolved.map((segment) => segment.text).join('\n\n'),
        detectedEncoding: parsed.detectedEncoding,
        sections: List.unmodifiable(sections),
        chunks: List.unmodifiable(chunks),
      );
    } on DataBankIngestionException {
      rethrow;
    } on FileSystemException catch (error) {
      throw DataBankIngestionException(
        DataBankIngestionFailureCode.ioFailure,
        'The document could not be read.',
        cause: error,
      );
    } on FormatException catch (error) {
      throw DataBankIngestionException(
        DataBankIngestionFailureCode.corruptDocument,
        'The document structure is invalid.',
        cause: error,
      );
    } catch (error) {
      throw DataBankIngestionException(
        DataBankIngestionFailureCode.corruptDocument,
        'The document could not be parsed.',
        cause: error,
      );
    } finally {
      if (stagingDirectory != null && stagingDirectory.existsSync()) {
        try {
          await stagingDirectory.delete(recursive: true);
        } on FileSystemException catch (error) {
          throw DataBankIngestionException(
            DataBankIngestionFailureCode.ioFailure,
            'Temporary document files could not be removed.',
            cause: error,
          );
        }
      }
    }
  }

  Future<_StagedSource> _stageAndHash(
    DataBankIngestionRequest request,
    File stagedFile,
  ) async {
    final byteSize = await request.sourceFile.length();
    final digestCompleter = Completer<Digest>();
    final digestSink = sha256.startChunkedConversion(
      ChunkedConversionSink.withCallback(
        (digests) => digestCompleter.complete(digests.single),
      ),
    );
    final output = stagedFile.openWrite();
    var copiedBytes = 0;
    var digestClosed = false;
    var outputClosed = false;
    try {
      await for (final bytes in request.sourceFile.openRead()) {
        request.cancellationToken.throwIfCancelled();
        digestSink.add(bytes);
        output.add(bytes);
        copiedBytes += bytes.length;
        _report(
          request,
          DataBankIngestionProgress(
            phase: DataBankIngestionPhase.staging,
            completedUnits: copiedBytes,
            totalUnits: byteSize,
          ),
        );
        request.cancellationToken.throwIfCancelled();
      }
      digestSink.close();
      digestClosed = true;
      await output.flush();
      await output.close();
      outputClosed = true;
      return _StagedSource(
        byteSize: copiedBytes,
        digest: (await digestCompleter.future).toString(),
      );
    } catch (_) {
      if (!digestClosed) {
        try {
          digestSink.close();
        } catch (_) {
          // Preserve the original staging error.
        }
      }
      if (!outputClosed) {
        try {
          await output.close();
        } catch (_) {
          // Preserve the original staging error.
        }
      }
      rethrow;
    }
  }

  Future<_ParsedDocument> _parse(
    File stagedFile,
    _SourceType sourceType,
    DataBankIngestionRequest request,
  ) async {
    switch (sourceType.format) {
      case DataBankDocumentFormat.plainText:
        return _parsePlainText(await stagedFile.readAsBytes(), request);
      case DataBankDocumentFormat.markdown:
        return _parseMarkdown(await stagedFile.readAsBytes(), request);
      case DataBankDocumentFormat.html:
        return _parseHtml(await stagedFile.readAsBytes(), request);
      case DataBankDocumentFormat.pdf:
        return _parsePdf(stagedFile, request);
      case DataBankDocumentFormat.epub:
        return _parseEpub(await stagedFile.readAsBytes(), request);
    }
  }

  _ParsedDocument _parsePlainText(
    Uint8List bytes,
    DataBankIngestionRequest request,
  ) {
    final decoded = _decodeText(bytes);
    _reportParseUnit(request, 1, 1);
    return _ParsedDocument(
      segments: [
        _SourceSegment(
          kind: DataBankSectionKind.section,
          text: decoded.text,
        ),
      ],
      detectedEncoding: decoded.encodingName,
    );
  }

  _ParsedDocument _parseMarkdown(
    Uint8List bytes,
    DataBankIngestionRequest request,
  ) {
    final decoded = _decodeText(bytes);
    final rendered = markdown.markdownToHtml(
      decoded.text,
      extensionSet: markdown.ExtensionSet.gitHubFlavored,
    );
    final parts = _parseStructuredHtml(rendered);
    _reportParseUnit(request, 1, 1);
    return _ParsedDocument(
      segments: parts
          .map(
            (part) => _SourceSegment(
              kind: DataBankSectionKind.section,
              title: part.title,
              text: part.text,
            ),
          )
          .toList(growable: false),
      detectedEncoding: decoded.encodingName,
    );
  }

  _ParsedDocument _parseHtml(
    Uint8List bytes,
    DataBankIngestionRequest request,
  ) {
    final decoded = _decodeText(bytes, inspectHtmlCharset: true);
    final parts = _parseStructuredHtml(decoded.text);
    _reportParseUnit(request, 1, 1);
    return _ParsedDocument(
      segments: parts
          .map(
            (part) => _SourceSegment(
              kind: DataBankSectionKind.section,
              title: part.title,
              text: part.text,
            ),
          )
          .toList(growable: false),
      detectedEncoding: decoded.encodingName,
    );
  }

  Future<_ParsedDocument> _parsePdf(
    File file,
    DataBankIngestionRequest request,
  ) async {
    final pages = await _pdfTextExtractor.extractPages(
      file,
      cancellationToken: request.cancellationToken,
      onProgress: (completed, total) {
        _reportParseUnit(request, completed, total);
      },
    );
    return _ParsedDocument(
      segments: pages
          .map(
            (page) => _SourceSegment(
              kind: DataBankSectionKind.section,
              pageStart: page.pageNumber,
              pageEnd: page.pageNumber,
              text: page.text,
            ),
          )
          .toList(growable: false),
    );
  }

  _ParsedDocument _parseEpub(
    Uint8List bytes,
    DataBankIngestionRequest request,
  ) {
    request.cancellationToken.throwIfCancelled();
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes, verify: true);
    } catch (error) {
      throw DataBankIngestionException(
        DataBankIngestionFailureCode.corruptDocument,
        'The EPUB archive is damaged.',
        cause: error,
      );
    }

    final entries = <String, ArchiveFile>{
      for (final entry in archive.files)
        if (entry.isFile) path.posix.normalize(entry.name): entry,
    };
    final container = _readArchiveText(
      entries,
      'META-INF/container.xml',
      description: 'EPUB container',
    );
    final containerXml = XmlDocument.parse(container);
    final rootFile = containerXml.descendants
        .whereType<XmlElement>()
        .where((element) => element.name.local == 'rootfile')
        .firstOrNull;
    final packagePath = rootFile?.getAttribute('full-path');
    if (packagePath == null || packagePath.trim().isEmpty) {
      throw const DataBankIngestionException(
        DataBankIngestionFailureCode.corruptDocument,
        'The EPUB does not declare a package document.',
      );
    }

    final normalizedPackagePath = path.posix.normalize(packagePath);
    final packageDirectory = path.posix.dirname(normalizedPackagePath);
    final packageXml = XmlDocument.parse(
      _readArchiveText(
        entries,
        normalizedPackagePath,
        description: 'EPUB package',
      ),
    );
    final manifest = <String, _EpubManifestItem>{};
    for (final item in packageXml.descendants
        .whereType<XmlElement>()
        .where((element) => element.name.local == 'item')) {
      final id = item.getAttribute('id');
      final href = item.getAttribute('href');
      if (id == null || href == null) continue;
      manifest[id] = _EpubManifestItem(
        id: id,
        archivePath: _resolveEpubPath(packageDirectory, href),
        mediaType: item.getAttribute('media-type') ?? '',
        properties: (item.getAttribute('properties') ?? '')
            .split(RegExp(r'\s+'))
            .where((value) => value.isNotEmpty)
            .toSet(),
      );
    }

    final spine = packageXml.descendants
        .whereType<XmlElement>()
        .where((element) => element.name.local == 'itemref')
        .map((element) => element.getAttribute('idref'))
        .whereType<String>()
        .map((id) => manifest[id])
        .whereType<_EpubManifestItem>()
        .toList(growable: false);
    if (spine.isEmpty) {
      throw const DataBankIngestionException(
        DataBankIngestionFailureCode.corruptDocument,
        'The EPUB reading order is empty.',
      );
    }

    final encryptedPaths = _readEncryptedEpubPaths(entries);
    if (spine.any((item) => encryptedPaths.contains(item.archivePath))) {
      throw const DataBankIngestionException(
        DataBankIngestionFailureCode.encryptedDocument,
        'The EPUB chapter content is encrypted.',
      );
    }

    final titlesByPath = _readEpubNavigationTitles(entries, manifest);
    final segments = <_SourceSegment>[];
    for (var spineIndex = 0; spineIndex < spine.length; spineIndex++) {
      request.cancellationToken.throwIfCancelled();
      final item = spine[spineIndex];
      if (item.mediaType != 'application/xhtml+xml' &&
          item.mediaType != 'text/html') {
        continue;
      }
      final chapterHtml = _readArchiveText(
        entries,
        item.archivePath,
        description: 'EPUB chapter',
      );
      final parts = _parseStructuredHtml(chapterHtml);
      final navigationTitle = titlesByPath[item.archivePath];
      for (var partIndex = 0; partIndex < parts.length; partIndex++) {
        final part = parts[partIndex];
        final title = _normalizeInlineText(
          part.title ??
              (partIndex == 0 ? navigationTitle : null) ??
              'Chapter ${spineIndex + 1}',
        );
        segments.add(
          _SourceSegment(
            kind: DataBankSectionKind.chapter,
            title: title,
            chapter: title,
            text: part.text,
          ),
        );
      }
      _reportParseUnit(request, spineIndex + 1, spine.length);
      request.cancellationToken.throwIfCancelled();
    }
    return _ParsedDocument(segments: segments);
  }

  List<DataBankSection> _buildSections(
    String versionId,
    List<_ResolvedSegment> segments,
  ) {
    return [
      for (final segment in segments)
        DataBankSection(
          id: '$versionId-section-${segment.ordinal + 1}',
          documentVersionId: versionId,
          kind: segment.source.kind,
          title: segment.source.title,
          ordinal: segment.ordinal,
          locator: DataBankSourceLocator(
            documentVersionId: versionId,
            sectionId: '$versionId-section-${segment.ordinal + 1}',
            pageStart: segment.source.pageStart,
            pageEnd: segment.source.pageEnd,
            chapter: segment.source.chapter,
            startOffset: segment.startOffset,
            endOffset: segment.endOffset,
          ),
        ),
    ];
  }

  List<DataBankTextChunk> _buildChunks(
    String versionId,
    List<_ResolvedSegment> segments,
    DataBankChunkingOptions options,
    DataBankIngestionRequest request,
  ) {
    final spans = <_ChunkSpan>[];
    for (var index = 0; index < segments.length; index++) {
      request.cancellationToken.throwIfCancelled();
      final segment = segments[index];
      switch (options.strategy) {
        case DataBankChunkingStrategy.fixedLength:
          spans.addAll(
            _fixedLengthSpans(
              segment,
              segment.startOffset,
              segment.endOffset,
              options.maxCharacters,
            ),
          );
        case DataBankChunkingStrategy.paragraph:
          spans.addAll(_paragraphSpans(segment, options.maxCharacters));
        case DataBankChunkingStrategy.chapter:
          spans.add(
            _ChunkSpan(
              segment: segment,
              startOffset: segment.startOffset,
              endOffset: segment.endOffset,
            ),
          );
      }
      _report(
        request,
        DataBankIngestionProgress(
          phase: DataBankIngestionPhase.chunking,
          completedUnits: index + 1,
          totalUnits: segments.length,
        ),
      );
    }

    return [
      for (var index = 0; index < spans.length; index++)
        DataBankTextChunk(
          id: '$versionId-chunk-${index + 1}',
          documentVersionId: versionId,
          sectionId: '$versionId-section-${spans[index].segment.ordinal + 1}',
          ordinal: index,
          text: spans[index].segment.documentText.substring(
                spans[index].startOffset,
                spans[index].endOffset,
              ),
          locator: DataBankSourceLocator(
            documentVersionId: versionId,
            sectionId: '$versionId-section-${spans[index].segment.ordinal + 1}',
            pageStart: spans[index].segment.source.pageStart,
            pageEnd: spans[index].segment.source.pageEnd,
            chapter: spans[index].segment.source.chapter,
            startOffset: spans[index].startOffset,
            endOffset: spans[index].endOffset,
          ),
        ),
    ];
  }

  List<_ChunkSpan> _paragraphSpans(
    _ResolvedSegment segment,
    int maxCharacters,
  ) {
    final spans = <_ChunkSpan>[];
    var cursor = segment.startOffset;
    while (cursor < segment.endOffset) {
      cursor = _skipWhitespace(
        segment.documentText,
        cursor,
        segment.endOffset,
      );
      if (cursor >= segment.endOffset) break;
      final delimiter = segment.documentText.indexOf('\n\n', cursor);
      final paragraphLimit = delimiter == -1 || delimiter >= segment.endOffset
          ? segment.endOffset
          : delimiter;
      final paragraphEnd = _trimEndWhitespace(
        segment.documentText,
        cursor,
        paragraphLimit,
      );
      if (paragraphEnd > cursor) {
        spans.addAll(
          _fixedLengthSpans(
            segment,
            cursor,
            paragraphEnd,
            maxCharacters,
          ),
        );
      }
      cursor = delimiter == -1 ? segment.endOffset : delimiter + 2;
    }
    return spans;
  }

  List<_ChunkSpan> _fixedLengthSpans(
    _ResolvedSegment segment,
    int rangeStart,
    int rangeEnd,
    int maxCharacters,
  ) {
    final spans = <_ChunkSpan>[];
    var cursor = rangeStart;
    while (cursor < rangeEnd) {
      cursor = _skipWhitespace(segment.documentText, cursor, rangeEnd);
      if (cursor >= rangeEnd) break;
      var chunkEnd = (cursor + maxCharacters).clamp(cursor + 1, rangeEnd);
      if (chunkEnd < rangeEnd &&
          !_isWhitespace(segment.documentText.codeUnitAt(chunkEnd))) {
        final candidate = segment.documentText.lastIndexOf(
          RegExp(r'\s'),
          chunkEnd,
        );
        if (candidate > cursor) chunkEnd = candidate;
      }
      chunkEnd = _trimEndWhitespace(
        segment.documentText,
        cursor,
        chunkEnd,
      );
      if (chunkEnd <= cursor) {
        chunkEnd = (cursor + maxCharacters).clamp(cursor + 1, rangeEnd);
      }
      spans.add(
        _ChunkSpan(
          segment: segment,
          startOffset: cursor,
          endOffset: chunkEnd,
        ),
      );
      cursor = chunkEnd;
    }
    return spans;
  }

  void _reportParseUnit(
    DataBankIngestionRequest request,
    int completed,
    int total,
  ) {
    _report(
      request,
      DataBankIngestionProgress(
        phase: DataBankIngestionPhase.parsing,
        completedUnits: completed,
        totalUnits: total,
      ),
    );
    request.cancellationToken.throwIfCancelled();
  }

  void _report(
    DataBankIngestionRequest request,
    DataBankIngestionProgress progress,
  ) {
    try {
      request.onProgress?.call(progress);
    } catch (_) {
      // A progress observer cannot invalidate an otherwise valid import.
    }
  }
}

_SourceType _resolveSourceType(String filePath, String? requestedMediaType) {
  final mediaType = requestedMediaType?.split(';').first.trim().toLowerCase();
  final byMediaType = switch (mediaType) {
    'text/plain' => const _SourceType(
        DataBankDocumentFormat.plainText,
        'text/plain',
      ),
    'text/markdown' || 'text/x-markdown' => const _SourceType(
        DataBankDocumentFormat.markdown,
        'text/markdown',
      ),
    'text/html' || 'application/xhtml+xml' => const _SourceType(
        DataBankDocumentFormat.html,
        'text/html',
      ),
    'application/pdf' => const _SourceType(
        DataBankDocumentFormat.pdf,
        'application/pdf',
      ),
    'application/epub+zip' => const _SourceType(
        DataBankDocumentFormat.epub,
        'application/epub+zip',
      ),
    null || '' => null,
    _ => throw DataBankIngestionException(
        DataBankIngestionFailureCode.unsupportedFormat,
        'Unsupported media type: $requestedMediaType',
      ),
  };
  if (byMediaType != null) return byMediaType;

  return switch (path.extension(filePath).toLowerCase()) {
    '.txt' => const _SourceType(
        DataBankDocumentFormat.plainText,
        'text/plain',
      ),
    '.md' || '.markdown' => const _SourceType(
        DataBankDocumentFormat.markdown,
        'text/markdown',
      ),
    '.html' || '.htm' => const _SourceType(
        DataBankDocumentFormat.html,
        'text/html',
      ),
    '.pdf' => const _SourceType(
        DataBankDocumentFormat.pdf,
        'application/pdf',
      ),
    '.epub' => const _SourceType(
        DataBankDocumentFormat.epub,
        'application/epub+zip',
      ),
    _ => throw DataBankIngestionException(
        DataBankIngestionFailureCode.unsupportedFormat,
        'Unsupported document extension: ${path.extension(filePath)}',
      ),
  };
}

_DecodedText _decodeText(
  Uint8List bytes, {
  bool inspectHtmlCharset = false,
}) {
  if (bytes.isEmpty) return const _DecodedText('', 'UTF-8');

  try {
    if (_startsWith(bytes, const [0xef, 0xbb, 0xbf])) {
      return _validatedDecodedText(
        utf8.decode(bytes.sublist(3), allowMalformed: false),
        'UTF-8',
      );
    }
    if (_startsWith(bytes, const [0xff, 0xfe, 0x00, 0x00]) ||
        _startsWith(bytes, const [0x00, 0x00, 0xfe, 0xff])) {
      return _validatedDecodedText(charset.utf32.decode(bytes), 'UTF-32');
    }
    if (_startsWith(bytes, const [0xff, 0xfe]) ||
        _startsWith(bytes, const [0xfe, 0xff])) {
      return _validatedDecodedText(charset.utf16.decode(bytes), 'UTF-16');
    }

    if (inspectHtmlCharset) {
      final declared = _declaredHtmlEncoding(bytes);
      if (declared != null) {
        return _validatedDecodedText(declared.decode(bytes), declared.name);
      }
    }

    try {
      return _validatedDecodedText(
        utf8.decode(bytes, allowMalformed: false),
        'UTF-8',
      );
    } on FormatException {
      final detected = charset.Charset.detect(
        bytes,
        orders: [
          charset.gbk,
          charset.shiftJis,
          charset.windows1252,
          latin1,
        ],
      );
      if (detected != null) {
        return _validatedDecodedText(detected.decode(bytes), detected.name);
      }
      rethrow;
    }
  } on FormatException catch (error) {
    throw DataBankIngestionException(
      DataBankIngestionFailureCode.invalidEncoding,
      'The text encoding could not be detected.',
      cause: error,
    );
  } on ArgumentError catch (error) {
    throw DataBankIngestionException(
      DataBankIngestionFailureCode.invalidEncoding,
      'The text encoding could not be decoded.',
      cause: error,
    );
  }
}

_DecodedText _validatedDecodedText(String text, String encodingName) {
  final normalized = text.startsWith('\ufeff') ? text.substring(1) : text;
  var disallowedControls = 0;
  for (final codePoint in normalized.runes) {
    if ((codePoint >= 0 && codePoint < 0x09) ||
        codePoint == 0x0b ||
        codePoint == 0x0c ||
        (codePoint > 0x0d && codePoint < 0x20)) {
      disallowedControls++;
    }
  }
  final toleratedControls =
      normalized.length < 200 ? 0 : normalized.length ~/ 100;
  if (normalized.contains('\ufffd') || disallowedControls > toleratedControls) {
    throw const DataBankIngestionException(
      DataBankIngestionFailureCode.invalidEncoding,
      'The source contains invalid text or binary control characters.',
    );
  }
  return _DecodedText(normalized, encodingName);
}

Encoding? _declaredHtmlEncoding(Uint8List bytes) {
  final prefix = latin1.decode(bytes.take(4096).toList());
  final match = RegExp(
    r'''<meta[^>]+charset\s*=\s*["']?\s*([^\s"'/>;]+)''',
    caseSensitive: false,
  ).firstMatch(prefix);
  return match == null ? null : charset.Charset.getByName(match.group(1)!);
}

List<_StructuredHtmlPart> _parseStructuredHtml(String source) {
  final document = html_parser.parse(source);
  document
      .querySelectorAll('script,style,noscript,template,svg,canvas')
      .forEach((element) => element.remove());
  document.querySelectorAll('br').forEach(
        (element) => element.replaceWith(html_dom.Text('\n')),
      );
  final root = document.body ?? document.documentElement;
  if (root == null) return const [];

  const headings = {'h1', 'h2', 'h3', 'h4', 'h5', 'h6'};
  const blocks = {
    ...headings,
    'p',
    'li',
    'blockquote',
    'pre',
    'td',
    'th',
    'dt',
    'dd',
  };
  final parts = <_StructuredHtmlPart>[];
  final content = <String>[];
  String? currentTitle = _nonBlank(document.querySelector('title')?.text);
  var currentTitleIsHeading = false;

  void finishPart() {
    if (content.isEmpty && !currentTitleIsHeading) return;
    final blockText = content.where((value) => value.isNotEmpty).join('\n\n');
    final text = _normalizeDocumentText(
      [if (currentTitle != null) currentTitle, blockText]
          .where((value) => value.isNotEmpty)
          .join('\n\n'),
    );
    if (text.isNotEmpty) {
      parts.add(_StructuredHtmlPart(title: currentTitle, text: text));
    }
    content.clear();
  }

  for (final element in root.querySelectorAll(blocks.join(','))) {
    if (_isHiddenHtmlElement(element, root)) {
      continue;
    }
    final name = element.localName;
    if (name == null) continue;
    final text = _normalizeDocumentText(element.text);
    if (text.isEmpty) continue;
    if (headings.contains(name)) {
      finishPart();
      currentTitle = _normalizeInlineText(text);
      currentTitleIsHeading = true;
      continue;
    }
    if (_hasSelectedBlockAncestor(element, root, blocks)) continue;
    content.add(text);
  }

  if (content.isEmpty && parts.isEmpty) {
    final fallback = _normalizeDocumentText(root.text);
    if (fallback.isNotEmpty) content.add(fallback);
  }
  finishPart();
  return parts;
}

bool _isHiddenHtmlElement(
  html_dom.Element element,
  html_dom.Element root,
) {
  html_dom.Element? candidate = element;
  while (candidate != null) {
    if (candidate.attributes.containsKey('hidden') ||
        candidate.attributes['aria-hidden']?.toLowerCase() == 'true') {
      return true;
    }
    if (candidate == root) break;
    candidate = candidate.parent;
  }
  return false;
}

bool _hasSelectedBlockAncestor(
  html_dom.Element element,
  html_dom.Element root,
  Set<String> blockNames,
) {
  html_dom.Element? ancestor = element.parent;
  while (ancestor != null && ancestor != root) {
    if (blockNames.contains(ancestor.localName)) return true;
    ancestor = ancestor.parent;
  }
  return false;
}

Set<String> _readEncryptedEpubPaths(Map<String, ArchiveFile> entries) {
  final entry = entries['META-INF/encryption.xml'];
  if (entry == null) return const {};
  final document = XmlDocument.parse(_archiveEntryText(entry));
  return document.descendants
      .whereType<XmlElement>()
      .where((element) => element.name.local == 'CipherReference')
      .map((element) => element.getAttribute('URI'))
      .whereType<String>()
      .map((value) => path.posix.normalize(Uri.decodeComponent(value)))
      .toSet();
}

Map<String, String> _readEpubNavigationTitles(
  Map<String, ArchiveFile> entries,
  Map<String, _EpubManifestItem> manifest,
) {
  final titles = <String, String>{};
  for (final item in manifest.values) {
    if (item.properties.contains('nav')) {
      final nav = entries[item.archivePath];
      if (nav == null) continue;
      final document = html_parser.parse(_archiveEntryText(nav));
      for (final anchor in document.querySelectorAll('a[href]')) {
        final href = anchor.attributes['href'];
        final title = _nonBlank(_normalizeInlineText(anchor.text));
        if (href == null || title == null) continue;
        titles[_resolveEpubPath(path.posix.dirname(item.archivePath), href)] =
            title;
      }
    }
    if (item.mediaType == 'application/x-dtbncx+xml') {
      final ncx = entries[item.archivePath];
      if (ncx == null) continue;
      final document = XmlDocument.parse(_archiveEntryText(ncx));
      for (final point in document.descendants
          .whereType<XmlElement>()
          .where((element) => element.name.local == 'navPoint')) {
        final source = point.descendants
            .whereType<XmlElement>()
            .where((element) => element.name.local == 'content')
            .firstOrNull
            ?.getAttribute('src');
        final title = point.descendants
            .whereType<XmlElement>()
            .where((element) => element.name.local == 'navLabel')
            .firstOrNull
            ?.innerText;
        final normalizedTitle = _nonBlank(_normalizeInlineText(title ?? ''));
        if (source == null || normalizedTitle == null) continue;
        titles[_resolveEpubPath(
          path.posix.dirname(item.archivePath),
          source,
        )] = normalizedTitle;
      }
    }
  }
  return titles;
}

String _readArchiveText(
  Map<String, ArchiveFile> entries,
  String archivePath, {
  required String description,
}) {
  final entry = entries[path.posix.normalize(archivePath)];
  if (entry == null) {
    throw DataBankIngestionException(
      DataBankIngestionFailureCode.corruptDocument,
      'The $description is missing.',
    );
  }
  return _archiveEntryText(entry);
}

String _archiveEntryText(ArchiveFile entry) {
  final content = entry.content;
  if (content is! List<int>) {
    throw const DataBankIngestionException(
      DataBankIngestionFailureCode.corruptDocument,
      'An EPUB entry could not be decoded.',
    );
  }
  return utf8.decode(content, allowMalformed: false);
}

String _resolveEpubPath(String baseDirectory, String reference) {
  final withoutFragment = reference.split('#').first;
  return path.posix.normalize(
    path.posix.join(baseDirectory, Uri.decodeComponent(withoutFragment)),
  );
}

List<_ResolvedSegment> _resolveSegments(List<_SourceSegment> sourceSegments) {
  final document = StringBuffer();
  final resolved = <_ResolvedSegment>[];
  for (final source in sourceSegments) {
    final text = _normalizeDocumentText(source.text);
    if (text.isEmpty) continue;
    if (document.isNotEmpty) document.write('\n\n');
    final start = document.length;
    document.write(text);
    final end = document.length;
    resolved.add(
      _ResolvedSegment(
        source: source,
        ordinal: resolved.length,
        startOffset: start,
        endOffset: end,
        text: text,
        documentText: '',
      ),
    );
  }
  final documentText = document.toString();
  return resolved
      .map((segment) => segment.withDocumentText(documentText))
      .toList(growable: false);
}

String _normalizeDocumentText(String value) {
  final lines = value
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .replaceAll('\u00a0', ' ')
      .replaceAll('\u0000', '')
      .split('\n')
      .map((line) => line.replaceAll(RegExp(r'[\t ]+'), ' ').trim())
      .toList();
  while (lines.isNotEmpty && lines.first.isEmpty) {
    lines.removeAt(0);
  }
  while (lines.isNotEmpty && lines.last.isEmpty) {
    lines.removeLast();
  }
  return lines.join('\n').replaceAll(RegExp(r'\n{3,}'), '\n\n');
}

String _normalizeInlineText(String value) {
  return value.replaceAll(RegExp(r'\s+'), ' ').trim();
}

String? _nonBlank(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return value.trim();
}

bool _startsWith(Uint8List bytes, List<int> prefix) {
  if (bytes.length < prefix.length) return false;
  for (var index = 0; index < prefix.length; index++) {
    if (bytes[index] != prefix[index]) return false;
  }
  return true;
}

int _skipWhitespace(String text, int start, int end) {
  var cursor = start;
  while (cursor < end && _isWhitespace(text.codeUnitAt(cursor))) {
    cursor++;
  }
  return cursor;
}

int _trimEndWhitespace(String text, int start, int end) {
  var cursor = end;
  while (cursor > start && _isWhitespace(text.codeUnitAt(cursor - 1))) {
    cursor--;
  }
  return cursor;
}

bool _isWhitespace(int codeUnit) {
  return codeUnit == 0x20 ||
      codeUnit == 0x09 ||
      codeUnit == 0x0a ||
      codeUnit == 0x0d;
}

final class _SourceType {
  final DataBankDocumentFormat format;
  final String mediaType;

  const _SourceType(this.format, this.mediaType);
}

final class _StagedSource {
  final int byteSize;
  final String digest;

  const _StagedSource({required this.byteSize, required this.digest});
}

final class _DecodedText {
  final String text;
  final String encodingName;

  const _DecodedText(this.text, this.encodingName);
}

final class _ParsedDocument {
  final List<_SourceSegment> segments;
  final String? detectedEncoding;

  const _ParsedDocument({required this.segments, this.detectedEncoding});
}

final class _SourceSegment {
  final DataBankSectionKind kind;
  final String? title;
  final int? pageStart;
  final int? pageEnd;
  final String? chapter;
  final String text;

  const _SourceSegment({
    required this.kind,
    this.title,
    this.pageStart,
    this.pageEnd,
    this.chapter,
    required this.text,
  });
}

final class _ResolvedSegment {
  final _SourceSegment source;
  final int ordinal;
  final int startOffset;
  final int endOffset;
  final String text;
  final String documentText;

  const _ResolvedSegment({
    required this.source,
    required this.ordinal,
    required this.startOffset,
    required this.endOffset,
    required this.text,
    required this.documentText,
  });

  _ResolvedSegment withDocumentText(String value) {
    return _ResolvedSegment(
      source: source,
      ordinal: ordinal,
      startOffset: startOffset,
      endOffset: endOffset,
      text: text,
      documentText: value,
    );
  }
}

final class _ChunkSpan {
  final _ResolvedSegment segment;
  final int startOffset;
  final int endOffset;

  const _ChunkSpan({
    required this.segment,
    required this.startOffset,
    required this.endOffset,
  });
}

final class _StructuredHtmlPart {
  final String? title;
  final String text;

  const _StructuredHtmlPart({required this.title, required this.text});
}

final class _EpubManifestItem {
  final String id;
  final String archivePath;
  final String mediaType;
  final Set<String> properties;

  const _EpubManifestItem({
    required this.id,
    required this.archivePath,
    required this.mediaType,
    required this.properties,
  });
}
