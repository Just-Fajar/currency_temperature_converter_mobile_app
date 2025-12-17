/// Structured logging system for the application.
///
/// Provides type-safe logging with different severity levels and
/// proper formatting for development and production environments.
///
/// Example:
/// ```dart
/// AppLogger.info('User logged in');
/// AppLogger.error('Network error', error, stackTrace);
/// AppLogger.debug('API Response: $data');
/// ```
library;

import 'package:flutter/foundation.dart';

import '../errors/failures.dart';

/// Log levels for filtering and categorization
enum LogLevel {
  debug(0, '🔍 DEBUG'),
  info(1, 'ℹ️ INFO'),
  warning(2, '⚠️ WARNING'),
  error(3, '❌ ERROR'),
  critical(4, '🔥 CRITICAL');

  final int priority;
  final String label;
  const LogLevel(this.priority, this.label);
}

/// Log entry with all contextual information
class LogEntry {
  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final String? tag;
  final Object? error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? context;

  LogEntry({
    required this.level,
    required this.message,
    required this.timestamp,
    this.tag,
    this.error,
    this.stackTrace,
    this.context,
  });

  /// Format log entry for display
  String format() {
    final buffer = StringBuffer();

    // Timestamp and level
    buffer.write('[${_formatTimestamp(timestamp)}] ');
    buffer.write('${level.label} ');

    // Tag
    if (tag != null) {
      buffer.write('[$tag] ');
    }

    // Message
    buffer.writeln(message);

    // Error
    if (error != null) {
      buffer.writeln('Error: $error');
    }

    // Context
    if (context != null && context!.isNotEmpty) {
      buffer.writeln('Context: $context');
    }

    // Stack trace (only for errors)
    if (stackTrace != null && level.priority >= LogLevel.error.priority) {
      buffer.writeln('Stack trace:');
      buffer.writeln(_formatStackTrace(stackTrace!));
    }

    return buffer.toString();
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}:'
        '${dt.second.toString().padLeft(2, '0')}.'
        '${dt.millisecond.toString().padLeft(3, '0')}';
  }

  String _formatStackTrace(StackTrace stackTrace) {
    final lines = stackTrace.toString().split('\n');
    // Take first 5 lines for brevity
    return lines.take(5).join('\n');
  }
}

/// Configuration for logger
class LoggerConfig {
  /// Minimum level to log (messages below this are ignored)
  final LogLevel minLevel;

  /// Whether to print logs to console
  final bool printToConsole;

  /// Whether to include stack traces for errors
  final bool includeStackTrace;

  /// Maximum number of log entries to keep in memory
  final int maxEntries;

  /// Custom log handler
  final void Function(LogEntry entry)? customHandler;

  const LoggerConfig({
    this.minLevel = kDebugMode ? LogLevel.debug : LogLevel.info,
    this.printToConsole = true,
    this.includeStackTrace = true,
    this.maxEntries = 1000,
    this.customHandler,
  });

  /// Development configuration
  static const development = LoggerConfig(
    minLevel: LogLevel.debug,
    printToConsole: true,
    includeStackTrace: true,
    maxEntries: 1000,
  );

  /// Production configuration
  static const production = LoggerConfig(
    minLevel: LogLevel.warning,
    printToConsole: false,
    includeStackTrace: false,
    maxEntries: 100,
  );
}

/// Main logger class
class AppLogger {
  static LoggerConfig _config = const LoggerConfig();
  static final List<LogEntry> _entries = [];

  /// Initialize logger with configuration
  static void configure(LoggerConfig config) {
    _config = config;
  }

  /// Log a debug message
  static void debug(
    String message, {
    String? tag,
    Map<String, dynamic>? context,
  }) {
    _log(level: LogLevel.debug, message: message, tag: tag, context: context);
  }

  /// Log an info message
  static void info(
    String message, {
    String? tag,
    Map<String, dynamic>? context,
  }) {
    _log(level: LogLevel.info, message: message, tag: tag, context: context);
  }

  /// Log a warning message
  static void warning(
    String message, {
    String? tag,
    Object? error,
    Map<String, dynamic>? context,
  }) {
    _log(
      level: LogLevel.warning,
      message: message,
      tag: tag,
      error: error,
      context: context,
    );
  }

  /// Log an error message
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    _log(
      level: LogLevel.error,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// Log a critical error message
  static void critical(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    _log(
      level: LogLevel.critical,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// Log a Failure object
  static void failure(
    Failure failure, {
    String? tag,
    String? additionalMessage,
    Map<String, dynamic>? context,
  }) {
    final message = additionalMessage != null
        ? '$additionalMessage: ${failure.message}'
        : failure.message;

    _log(
      level: LogLevel.error,
      message: message,
      tag: tag ?? failure.code,
      error: failure.originalError,
      stackTrace: failure.stackTrace,
      context: {
        'failureType': failure.runtimeType.toString(),
        'code': failure.code,
        if (context != null) ...context,
      },
    );
  }

  /// Log an API request
  static void apiRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    Object? body,
  }) {
    _log(
      level: LogLevel.debug,
      message: 'API Request: $method $url',
      tag: 'API',
      context: {
        'method': method,
        'url': url,
        if (headers != null) 'headers': headers,
        if (body != null) 'body': body,
      },
    );
  }

  /// Log an API response
  static void apiResponse({
    required String method,
    required String url,
    required int statusCode,
    Object? body,
    Duration? duration,
  }) {
    final level = statusCode >= 400 ? LogLevel.error : LogLevel.debug;

    _log(
      level: level,
      message: 'API Response: $method $url ($statusCode)',
      tag: 'API',
      context: {
        'method': method,
        'url': url,
        'statusCode': statusCode,
        if (body != null) 'body': body,
        if (duration != null) 'duration': '${duration.inMilliseconds}ms',
      },
    );
  }

  /// Log performance metrics
  static void performance({
    required String operation,
    required Duration duration,
    Map<String, dynamic>? metrics,
  }) {
    _log(
      level: LogLevel.info,
      message: 'Performance: $operation took ${duration.inMilliseconds}ms',
      tag: 'PERF',
      context: {
        'operation': operation,
        'duration_ms': duration.inMilliseconds,
        if (metrics != null) ...metrics,
      },
    );
  }

  /// Log user action
  static void userAction({
    required String action,
    Map<String, dynamic>? properties,
  }) {
    _log(
      level: LogLevel.info,
      message: 'User action: $action',
      tag: 'USER',
      context: {'action': action, if (properties != null) ...properties},
    );
  }

  /// Get all log entries
  static List<LogEntry> get entries => List.unmodifiable(_entries);

  /// Get log entries by level
  static List<LogEntry> getByLevel(LogLevel level) {
    return _entries.where((e) => e.level == level).toList();
  }

  /// Get log entries by tag
  static List<LogEntry> getByTag(String tag) {
    return _entries.where((e) => e.tag == tag).toList();
  }

  /// Clear all log entries
  static void clear() {
    _entries.clear();
  }

  /// Export logs as string
  static String export() {
    final buffer = StringBuffer();
    buffer.writeln('=== Application Logs ===');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('Total entries: ${_entries.length}');
    buffer.writeln();

    for (final entry in _entries) {
      buffer.writeln(entry.format());
      buffer.writeln('---');
    }

    return buffer.toString();
  }

  // Internal logging method
  static void _log({
    required LogLevel level,
    required String message,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    // Check minimum level
    if (level.priority < _config.minLevel.priority) {
      return;
    }

    // Create log entry
    final entry = LogEntry(
      level: level,
      message: message,
      timestamp: DateTime.now(),
      tag: tag,
      error: error,
      stackTrace: _config.includeStackTrace ? stackTrace : null,
      context: context,
    );

    // Store entry
    _entries.add(entry);

    // Limit entries
    if (_entries.length > _config.maxEntries) {
      _entries.removeAt(0);
    }

    // Print to console
    if (_config.printToConsole && kDebugMode) {
      _printToConsole(entry);
    }

    // Custom handler
    _config.customHandler?.call(entry);
  }

  static void _printToConsole(LogEntry entry) {
    final formatted = entry.format();

    // Use appropriate print method based on level
    switch (entry.level) {
      case LogLevel.debug:
      case LogLevel.info:
        debugPrint(formatted);
        break;
      case LogLevel.warning:
      case LogLevel.error:
      case LogLevel.critical:
        debugPrint(formatted);
        break;
    }
  }
}

/// Mixin for classes that need logging
mixin Loggable {
  /// Tag for this class (defaults to class name)
  String get logTag => runtimeType.toString();

  void logDebug(String message, {Map<String, dynamic>? context}) {
    AppLogger.debug(message, tag: logTag, context: context);
  }

  void logInfo(String message, {Map<String, dynamic>? context}) {
    AppLogger.info(message, tag: logTag, context: context);
  }

  void logWarning(
    String message, {
    Object? error,
    Map<String, dynamic>? context,
  }) {
    AppLogger.warning(message, tag: logTag, error: error, context: context);
  }

  void logError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    AppLogger.error(
      message,
      tag: logTag,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  void logFailure(Failure failure, {String? additionalMessage}) {
    AppLogger.failure(
      failure,
      tag: logTag,
      additionalMessage: additionalMessage,
    );
  }
}
