/// Helpers for files opened from the OS Files app / share sheet.
///
/// Flutter deep linking turns `file://` and `content://` URIs into GoRouter
/// locations. Those must never be shown as "Page not found".
class OpenedDocument {
  static const backupExtensions = {'.ntx', '.ntb', '.ntm'};
  static const importExtensions = {'.jsonl', '.json', '.png', '.webp'};

  static bool isBackupPath(String filePath) {
    final lower = filePath.toLowerCase();
    return backupExtensions.any(lower.endsWith);
  }

  static bool isImportPath(String filePath) {
    final lower = filePath.toLowerCase();
    return importExtensions.any(lower.endsWith);
  }

  /// True when [uri] is an OS-opened document rather than an in-app route.
  static bool isExternalDocumentUri(Uri uri) {
    final scheme = uri.scheme.toLowerCase();
    if (scheme == 'file' || scheme == 'content') {
      return true;
    }
    if (scheme.isNotEmpty && scheme != 'http' && scheme != 'https') {
      final path = uri.path.toLowerCase();
      if (isBackupPath(path) || isImportPath(path)) {
        return true;
      }
    }
    final path = uri.path.toLowerCase();
    if (isBackupPath(path)) {
      return true;
    }
    // Cold-start deep links can look like `/private/var/.../backup.ntx`.
    if (path.contains('/private/') ||
        path.contains('/var/mobile/') ||
        path.contains('/containers/') ||
        path.contains('/tmp/') ||
        path.contains('/cache')) {
      if (isBackupPath(path) || isImportPath(path)) {
        return true;
      }
    }
    return false;
  }

  static String? filePathFromUri(Uri uri) {
    if (uri.scheme == 'file') {
      return Uri.decodeFull(uri.path);
    }
    if (uri.path.isNotEmpty && isBackupPath(uri.path)) {
      return Uri.decodeFull(uri.path);
    }
    return null;
  }
}
