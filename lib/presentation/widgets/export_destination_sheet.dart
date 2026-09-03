import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:native_tavern/core/utils/share_utils.dart';
import 'package:native_tavern/domain/services/file_export_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Lets the user share an export or save it to the system Files app.
Future<void> exportBytesWithDestination({
  required BuildContext context,
  required String fileName,
  required List<int> bytes,
  required String subject,
  List<String>? allowedExtensions,
  String? mimeType,
  String? dialogTitle,
}) async {
  final l10n = AppLocalizations.of(context);
  final shareOrigin = sharePositionOrigin(context);
  final choice = await showModalBottomSheet<String>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: Text(l10n.exportToFiles),
            onTap: () => Navigator.pop(context, 'files'),
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: Text(l10n.shareBackup),
            onTap: () => Navigator.pop(context, 'share'),
          ),
        ],
      ),
    ),
  );

  if (choice == null || !context.mounted) return;

  if (choice == 'files') {
    final outcome = await fileExportService.exportFile(
      fileName: fileName,
      bytes: bytes,
      allowedExtensions:
          allowedExtensions ?? [path.extension(fileName).replaceFirst('.', '')],
      dialogTitle: dialogTitle ?? l10n.exportToFiles,
    );
    if (!context.mounted) return;
    final message = outcome.savedToFilesApp
        ? l10n.savedToFilesApp
        : outcome.cancelled
            ? null
            : l10n.exportFailed(outcome.error ?? l10n.error);
    if (message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
    return;
  }

  final tempDir = await getTemporaryDirectory();
  final file = File(path.join(tempDir.path, fileName));
  await file.writeAsBytes(bytes, flush: true);
  await SharePlus.instance.share(
    ShareParams(
      files: [
        XFile(file.path, mimeType: mimeType, name: fileName),
      ],
      subject: subject,
      sharePositionOrigin: shareOrigin,
    ),
  );
}

Future<void> exportTextWithDestination({
  required BuildContext context,
  required String fileName,
  required String content,
  required String subject,
  List<String>? allowedExtensions,
  String? mimeType,
  String? dialogTitle,
}) {
  return exportBytesWithDestination(
    context: context,
    fileName: fileName,
    bytes: utf8.encode(content),
    subject: subject,
    allowedExtensions: allowedExtensions,
    mimeType: mimeType ?? 'text/plain',
    dialogTitle: dialogTitle,
  );
}
