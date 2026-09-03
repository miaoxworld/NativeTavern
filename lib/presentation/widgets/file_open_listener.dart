import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/file_export_service.dart';
import 'package:native_tavern/domain/services/file_open_service.dart';
import 'package:native_tavern/domain/services/opened_document.dart';
import 'package:native_tavern/presentation/providers/cloud_backup_providers.dart';
import 'package:native_tavern/presentation/router/app_router.dart';

/// Routes files opened from the system Files app / share sheet into the
/// matching in-app import flow.
class FileOpenListener extends ConsumerStatefulWidget {
  final Widget child;

  const FileOpenListener({super.key, required this.child});

  @override
  ConsumerState<FileOpenListener> createState() => _FileOpenListenerState();
}

class _FileOpenListenerState extends ConsumerState<FileOpenListener> {
  StreamSubscription<String>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bind());
  }

  Future<void> _bind() async {
    if (!mounted) return;
    await fileExportService.prepareBackupFolderVisibility();
    final service = ref.read(fileOpenServiceProvider);
    final initial = await service.getInitialFile();
    if (initial != null && mounted) {
      _handleOpenedFile(initial);
    }
    _subscription = service.onFileOpened.listen(_handleOpenedFile);
  }

  void _handleOpenedFile(String filePath) {
    if (!mounted || filePath.isEmpty) return;
    final router = ref.read(appRouterProvider);
    if (OpenedDocument.isBackupPath(filePath)) {
      ref.read(pendingBackupImportPathProvider.notifier).state = filePath;
      if (router.routeInformationProvider.value.uri.path !=
          AppRoutes.cloudBackupSettings) {
        router.push(AppRoutes.cloudBackupSettings);
      }
      return;
    }

    ref.read(pendingImportFilePathProvider.notifier).state = filePath;
    if (router.routeInformationProvider.value.uri.path != AppRoutes.import_) {
      router.push(AppRoutes.import_);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
