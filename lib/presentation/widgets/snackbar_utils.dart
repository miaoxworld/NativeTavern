import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Log a message to the console with SnackBar context
void _logSnackBar(String message, {String? error, StackTrace? stackTrace}) {
  final timestamp = DateTime.now().toIso8601String();
  final logMessage = '[$timestamp] SnackBar: $message';
  
  if (kDebugMode) {
    debugPrint(logMessage);
    if (error != null) {
      debugPrint('  Error: $error');
    }
  }
  
  developer.log(
    message,
    name: 'SnackBar',
    error: error,
    stackTrace: stackTrace,
  );
}

/// Show a SnackBar with automatic logging
/// 
/// This utility function wraps ScaffoldMessenger.showSnackBar with logging
/// to help debug UI messages in production.
void showLoggedSnackBar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 4),
  SnackBarAction? action,
  Color? backgroundColor,
  bool isError = false,
}) {
  _logSnackBar(message, error: isError ? message : null);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      action: action,
      backgroundColor: isError ? Colors.red.shade700 : backgroundColor,
    ),
  );
}

/// Show an error SnackBar with automatic logging
void showErrorSnackBar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 4),
  SnackBarAction? action,
  Object? error,
  StackTrace? stackTrace,
}) {
  _logSnackBar(message, error: error?.toString(), stackTrace: stackTrace);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      action: action,
      backgroundColor: Colors.red.shade700,
    ),
  );
}

/// Show a success SnackBar with automatic logging
void showSuccessSnackBar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 2),
  SnackBarAction? action,
}) {
  _logSnackBar(message);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      action: action,
      backgroundColor: Colors.green.shade700,
    ),
  );
}

/// Extension on ScaffoldMessengerState to add logging
extension LoggedSnackBarExtension on ScaffoldMessengerState {
  /// Show a SnackBar with automatic logging
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showLoggedSnackBar(
    SnackBar snackBar, {
    String? logMessage,
  }) {
    final message = logMessage ?? 
        (snackBar.content is Text ? (snackBar.content as Text).data : 'SnackBar shown');
    _logSnackBar(message ?? 'SnackBar shown');
    return showSnackBar(snackBar);
  }
}