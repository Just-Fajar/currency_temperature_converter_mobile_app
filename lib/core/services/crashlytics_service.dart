// NOTE: Firebase Crashlytics is currently disabled for demo purposes
// To enable: Add firebase_core and firebase_crashlytics to pubspec.yaml
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../errors/failures.dart';
import '../logging/app_logger.dart';

/// Service for handling crash reporting and error tracking with Firebase Crashlytics.
///
/// Provides a centralized way to report errors, crashes, and failures to Firebase
/// for monitoring and debugging in production.
///
/// NOTE: Currently using stub implementation. To enable Firebase Crashlytics:
/// 1. Add firebase_core and firebase_crashlytics to pubspec.yaml
/// 2. Uncomment Firebase imports
/// 3. Replace stub implementations with actual Firebase calls
///
/// Example:
/// ```dart
/// try {
///   await riskyOperation();
/// } catch (e, stackTrace) {
///   await CrashlyticsService.recordError(e, stackTrace);
/// }
/// ```
class CrashlyticsService {
  // Stub implementation - replace with: FirebaseCrashlytics.instance
  // static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Initialize Crashlytics service
  static Future<void> initialize() async {
    // Stub: Crashlytics is initialized automatically with Firebase.initializeApp()
    AppLogger.info('Crashlytics service initialized (stub mode)');
  }

  /// Record a non-fatal error to Crashlytics
  ///
  /// [error] The error object to record
  /// [stackTrace] Optional stack trace
  /// [reason] Human-readable reason for the error
  /// [information] Additional key-value context
  /// [fatal] Whether this is a fatal error (default: false)
  static Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? information,
    bool fatal = false,
  }) async {
    try {
      // Log locally first
      AppLogger.error(
        reason ?? 'Error occurred',
        error: error,
        stackTrace: stackTrace,
        context: information,
      );

      // Stub: Would record to Firebase Crashlytics
      // await _crashlytics.recordError(error, stackTrace, ...);
    } catch (e) {
      AppLogger.error('Failed to record error to Crashlytics', error: e);
    }
  }

  /// Record a Failure object to Crashlytics
  ///
  /// Automatically extracts relevant information from the Failure
  static Future<void> recordFailure(
    Failure failure, {
    String? additionalInfo,
    bool fatal = false,
  }) async {
    // Only report failures that should be tracked
    if (!failure.shouldReport) {
      AppLogger.debug('Skipping Crashlytics report for ${failure.runtimeType}');
      return;
    }

    await recordError(
      failure.originalError ?? failure,
      failure.stackTrace,
      reason: failure.code ?? failure.runtimeType.toString(),
      information: {
        'message': failure.message,
        'code': failure.code ?? 'N/A',
        'type': failure.runtimeType.toString(),
        'userMessage': failure.userMessage,
        if (additionalInfo != null) 'additional': additionalInfo,
      },
      fatal: fatal,
    );
  }

  /// Log a message to Crashlytics (appears in crash reports)
  ///
  /// Use for breadcrumb trails to understand user flow before crashes
  static Future<void> log(String message) async {
    // Stub: await _crashlytics.log(message);
    AppLogger.debug('Crashlytics log: $message', tag: 'Crashlytics');
  }

  /// Set user identifier for crash reports
  ///
  /// Call this after user login to associate crashes with users
  static Future<void> setUser({
    required String userId,
    String? email,
    String? name,
  }) async {
    // Stub: await _crashlytics.setUserIdentifier(userId);
    // Stub: await _crashlytics.setCustomKey('email', email);
    // Stub: await _crashlytics.setCustomKey('name', name);

    AppLogger.info('Crashlytics user set', context: {'userId': userId});
  }

  /// Clear user identifier (call on logout)
  static Future<void> clearUser() async {
    // Stub: await _crashlytics.setUserIdentifier('');
    AppLogger.info('Crashlytics user cleared');
  }

  /// Set a custom key-value pair for crash context
  static Future<void> setCustomKey(String key, dynamic value) async {
    // Stub: await _crashlytics.setCustomKey(key, value);
  }

  /// Set multiple custom keys at once
  static Future<void> setCustomKeys(Map<String, dynamic> keys) async {
    for (final entry in keys.entries) {
      await setCustomKey(entry.key, entry.value);
    }
  }

  /// Force a crash (for testing only)
  ///
  /// ⚠️ WARNING: This will crash the app! Only use in debug builds.
  static void forceCrash() {
    AppLogger.warning(
      'Force crashing app for testing (stub - not actually crashing)',
    );
    // Stub: _crashlytics.crash();
  }

  /// Check if crash reporting is currently enabled
  static Future<bool> isCrashlyticsCollectionEnabled() async {
    // Stub: return _crashlytics.isCrashlyticsCollectionEnabled();
    return false; // Stub mode
  }

  /// Enable or disable crash reporting
  ///
  /// Use this to allow users to opt-out of crash reporting
  static Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    // Stub: await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
    AppLogger.info(
      'Crashlytics collection ${enabled ? 'enabled' : 'disabled'} (stub mode)',
    );
  }

  /// Record a breadcrumb for debugging
  ///
  /// Breadcrumbs help understand user actions leading to a crash
  static Future<void> breadcrumb(String message) async {
    await log('🔖 $message');
  }

  /// Record screen view (for navigation tracking)
  static Future<void> screenView(String screenName) async {
    await log('📱 Screen: $screenName');
    await setCustomKey('last_screen', screenName);
  }

  /// Record user action (for interaction tracking)
  static Future<void> userAction(
    String action, {
    Map<String, dynamic>? properties,
  }) async {
    final message = properties != null
        ? '👆 Action: $action (${properties.entries.map((e) => '${e.key}=${e.value}').join(', ')})'
        : '👆 Action: $action';

    await log(message);
  }

  /// Record API call (for network debugging)
  static Future<void> apiCall({
    required String method,
    required String endpoint,
    int? statusCode,
  }) async {
    await log(
      '🌐 API: $method $endpoint ${statusCode != null ? '($statusCode)' : ''}',
    );
  }

  /// Record app lifecycle event
  static Future<void> lifecycleEvent(String event) async {
    await log('🔄 Lifecycle: $event');
  }
}

/// Mixin for classes that need Crashlytics integration
mixin CrashlyticsLoggable {
  /// Record error with class context
  Future<void> recordErrorWithContext(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? information,
  }) async {
    final contextInfo = {
      'class': runtimeType.toString(),
      if (information != null) ...information,
    };

    await CrashlyticsService.recordError(
      error,
      stackTrace,
      reason: reason,
      information: contextInfo,
    );
  }

  /// Record failure with class context
  Future<void> recordFailureWithContext(
    Failure failure, {
    String? additionalInfo,
  }) async {
    final info = additionalInfo != null
        ? '$additionalInfo (in ${runtimeType.toString()})'
        : 'Error in ${runtimeType.toString()}';

    await CrashlyticsService.recordFailure(failure, additionalInfo: info);
  }
}
