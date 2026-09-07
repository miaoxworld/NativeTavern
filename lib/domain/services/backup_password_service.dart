import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cryptography/cryptography.dart';

/// Thrown when a password-protected `.ntx` is opened without a password.
class BackupPasswordRequiredException implements Exception {
  const BackupPasswordRequiredException();

  @override
  String toString() => 'This backup requires a password.';
}

/// Thrown when the password cannot decrypt a protected `.ntx`.
class BackupPasswordInvalidException implements Exception {
  const BackupPasswordInvalidException();

  @override
  String toString() => 'That backup password is incorrect.';
}

/// AES-256-GCM wrapper for portable `.ntx` backups.
///
/// Automatic iCloud / Google Drive sync is not password-gated. This protects
/// files the user saves or shares. The password is never stored; forgetting it
/// makes the backup unrecoverable.
class BackupPasswordService {
  static const algorithmName = 'A256GCM';
  static const kdfName = 'PBKDF2-HMAC-SHA256';
  static const defaultIterations = 210000;
  static const minPasswordLength = 8;
  static const saltLength = 16;
  static const maxIterations = 2000000;

  BackupPasswordService({
    this.iterations = defaultIterations,
    Random? random,
  }) : _random = random ?? Random.secure();

  final int iterations;
  final Random _random;
  final AesGcm _aes = AesGcm.with256bits();

  static bool isProtectedManifest(Map<String, dynamic> manifest) =>
      manifest['encrypted'] == true;

  static bool isProtectedArchive(Archive archive) {
    final manifest = readManifest(archive);
    return manifest != null && isProtectedManifest(manifest);
  }

  static Map<String, dynamic>? readManifest(Archive archive) {
    ArchiveFile? entry;
    for (final file in archive.files) {
      if (file.isFile && file.name == 'manifest.json') {
        entry = file;
        break;
      }
    }
    if (entry == null) return null;
    final decoded = jsonDecode(utf8.decode(_bytesOf(entry)));
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return decoded.cast<String, dynamic>();
    return null;
  }

  void validatePassword(String password) {
    if (password.length < minPasswordLength) {
      throw ArgumentError.value(
        password,
        'password',
        'Backup password must be at least $minPasswordLength characters.',
      );
    }
  }

  Future<Uint8List> protectZip({
    required List<int> zipBytes,
    required String password,
  }) async {
    validatePassword(password);
    final salt = _randomBytes(saltLength);
    final secretKey = await _deriveKey(password, salt, iterations);
    final box = await _aes.encrypt(zipBytes, secretKey: secretKey);
    final manifest = utf8.encode(
      jsonEncode({
        'version': 1,
        'app': 'NativeTavern',
        'format': 'ntx',
        'encrypted': true,
        'kdf': kdfName,
        'iter': iterations,
        'salt': base64Encode(salt),
        'alg': algorithmName,
        'n': base64Encode(box.nonce),
        't': base64Encode(box.mac.bytes),
      }),
    );
    final archive = Archive()
      ..addFile(ArchiveFile('manifest.json', manifest.length, manifest))
      ..addFile(
        ArchiveFile('payload.bin', box.cipherText.length, box.cipherText),
      );
    return Uint8List.fromList(ZipEncoder().encode(archive));
  }

  Future<Uint8List> unlockZip({
    required List<int> zipBytes,
    required String password,
  }) async {
    final archive = ZipDecoder().decodeBytes(zipBytes, verify: true);
    return unlockArchive(archive: archive, password: password);
  }

  Future<Uint8List> unlockArchive({
    required Archive archive,
    required String password,
  }) async {
    final manifest = readManifest(archive);
    if (manifest == null || !isProtectedManifest(manifest)) {
      throw const FormatException('Backup is not password-protected');
    }
    if (manifest['app'] != 'NativeTavern' || manifest['format'] != 'ntx') {
      throw const FormatException('Unsupported combined backup');
    }
    if (manifest['kdf'] != kdfName || manifest['alg'] != algorithmName) {
      throw const FormatException('Unsupported backup encryption');
    }
    final iter = manifest['iter'];
    if (iter is! int || iter < 1 || iter > maxIterations) {
      throw const FormatException('Invalid backup key-derivation parameters');
    }
    final salt = manifest['salt'];
    final nonce = manifest['n'];
    final mac = manifest['t'];
    if (salt is! String || nonce is! String || mac is! String) {
      throw const FormatException('Password-protected backup is incomplete');
    }

    ArchiveFile? payload;
    for (final file in archive.files) {
      if (file.isFile && file.name == 'payload.bin') {
        payload = file;
        break;
      }
    }
    if (payload == null) {
      throw const FormatException('Password-protected backup is missing payload');
    }

    try {
      final secretKey = await _deriveKey(password, base64Decode(salt), iter);
      final clear = await _aes.decrypt(
        SecretBox(
          _bytesOf(payload),
          nonce: base64Decode(nonce),
          mac: Mac(base64Decode(mac)),
        ),
        secretKey: secretKey,
      );
      return Uint8List.fromList(clear);
    } catch (_) {
      throw const BackupPasswordInvalidException();
    }
  }

  Future<SecretKey> _deriveKey(
    String password,
    List<int> salt,
    int iter,
  ) {
    return Pbkdf2.hmacSha256(iterations: iter, bits: 256).deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
  }

  Uint8List _randomBytes(int length) {
    return Uint8List.fromList(
      List<int>.generate(length, (_) => _random.nextInt(256)),
    );
  }

  static Uint8List _bytesOf(ArchiveFile file) {
    return Uint8List.fromList(file.content);
  }
}
