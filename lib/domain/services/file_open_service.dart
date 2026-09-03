import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service that handles files opened externally by the OS (iOS AirDrop/Files, Android Send/View)
class FileOpenService {
  static const MethodChannel _channel =
      MethodChannel('com.nativetavern/file_open');

  final _fileOpenController = StreamController<String>.broadcast();
  Stream<String> get onFileOpened => _fileOpenController.stream;

  FileOpenService() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onFileOpened') {
      final path = call.arguments as String?;
      if (path != null && path.isNotEmpty) {
        _fileOpenController.add(path);
      }
    }
  }

  /// Check if the app was launched with a file
  Future<String?> getInitialFile() async {
    try {
      final initialFile = await _channel.invokeMethod<String>('getInitialFile');
      return initialFile;
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _fileOpenController.close();
  }
}

final fileOpenServiceProvider = Provider<FileOpenService>((ref) {
  final service = FileOpenService();
  ref.onDispose(service.dispose);
  return service;
});
