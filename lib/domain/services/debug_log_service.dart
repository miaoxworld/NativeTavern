import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Log entry model
class LogEntry {
  final DateTime timestamp;
  final String level;
  final String message;
  final String? source;
  final String? error;
  final StackTrace? stackTrace;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.source,
    this.error,
    this.stackTrace,
  });

  String get formattedTime {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    final s = timestamp.second.toString().padLeft(2, '0');
    final ms = timestamp.millisecond.toString().padLeft(3, '0');
    return '$h:$m:$s.$ms';
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('[$formattedTime] ');
    if (source != null) {
      buffer.write('[$source] ');
    }
    buffer.write('[$level] ');
    buffer.write(message);
    if (error != null) {
      buffer.write('\n  Error: $error');
    }
    if (stackTrace != null) {
      buffer.write('\n  Stack: $stackTrace');
    }
    return buffer.toString();
  }
}

/// Debug log service that captures and stores logs
class DebugLogService {
  static final DebugLogService _instance = DebugLogService._internal();
  factory DebugLogService() => _instance;
  DebugLogService._internal();

  static const int _maxLogs = 1000;
  final Queue<LogEntry> _logs = Queue<LogEntry>();
  final _logController = StreamController<LogEntry>.broadcast();
  
  bool _isCapturing = false;
  DebugPrintCallback? _originalDebugPrint;

  /// Stream of new log entries
  Stream<LogEntry> get logStream => _logController.stream;

  /// Get all current logs
  List<LogEntry> get logs => _logs.toList();

  /// Whether log capturing is active
  bool get isCapturing => _isCapturing;

  /// Start capturing logs
  void startCapturing() {
    if (_isCapturing) return;
    _isCapturing = true;

    // Override debugPrint to capture Flutter logs
    _originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      // Call original debugPrint
      _originalDebugPrint?.call(message, wrapWidth: wrapWidth);
      
      // Capture the log
      if (message != null) {
        _addLog(LogEntry(
          timestamp: DateTime.now(),
          level: 'DEBUG',
          message: message,
          source: 'Flutter',
        ));
      }
    };

    // Add initial log entry
    _addLog(LogEntry(
      timestamp: DateTime.now(),
      level: 'INFO',
      message: 'Debug log capturing started',
      source: 'DebugLogService',
    ));
  }

  /// Stop capturing logs
  void stopCapturing() {
    if (!_isCapturing) return;
    _isCapturing = false;

    // Restore original debugPrint
    if (_originalDebugPrint != null) {
      debugPrint = _originalDebugPrint!;
      _originalDebugPrint = null;
    }

    _addLog(LogEntry(
      timestamp: DateTime.now(),
      level: 'INFO',
      message: 'Debug log capturing stopped',
      source: 'DebugLogService',
    ));
  }

  /// Add a log entry manually
  void log(
    String message, {
    String level = 'INFO',
    String? source,
    String? error,
    StackTrace? stackTrace,
  }) {
    if (!_isCapturing) return;
    
    _addLog(LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      source: source,
      error: error,
      stackTrace: stackTrace,
    ));

    // Also log to developer console
    developer.log(
      message,
      name: source ?? 'App',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void _addLog(LogEntry entry) {
    _logs.add(entry);
    
    // Keep only the last _maxLogs entries
    while (_logs.length > _maxLogs) {
      _logs.removeFirst();
    }
    
    _logController.add(entry);
  }

  /// Clear all logs
  void clearLogs() {
    _logs.clear();
  }

  /// Export logs as string
  String exportLogs() {
    return _logs.map((e) => e.toString()).join('\n');
  }

  /// Dispose the service
  void dispose() {
    stopCapturing();
    _logController.close();
  }
}

/// Provider for debug log service
final debugLogServiceProvider = Provider<DebugLogService>((ref) {
  return DebugLogService();
});

/// Provider for log entries stream
final logEntriesStreamProvider = StreamProvider<LogEntry>((ref) {
  final service = ref.watch(debugLogServiceProvider);
  return service.logStream;
});

/// Provider for all current logs
final currentLogsProvider = Provider<List<LogEntry>>((ref) {
  // Watch the stream to trigger rebuilds
  ref.watch(logEntriesStreamProvider);
  final service = ref.watch(debugLogServiceProvider);
  return service.logs;
});
