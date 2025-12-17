import 'package:flutter/material.dart';

import '../../../core/errors/failures.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/services/crashlytics_service.dart';

/// Error boundary widget that catches and handles errors in the widget tree.
///
/// Wraps child widgets and catches any errors that occur during build,
/// displaying a fallback UI instead of crashing the app.
///
/// Example:
/// ```dart
/// ErrorBoundary(
///   child: MyWidget(),
///   onError: (error, stackTrace) {
///     // Custom error handling
///   },
/// )
/// ```
class ErrorBoundary extends StatefulWidget {
  /// Child widget to wrap
  final Widget child;

  /// Custom error builder (optional)
  final Widget Function(Object error, StackTrace stackTrace)? errorBuilder;

  /// Callback when error occurs
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// Whether to report errors to Crashlytics
  final bool reportToCrashlytics;

  /// Tag for error logging
  final String? tag;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
    this.reportToCrashlytics = true,
    this.tag,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null && _stackTrace != null) {
      // Show error UI
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error!, _stackTrace!);
      }
      return _buildDefaultErrorUI(context, _error!, _stackTrace!);
    }

    // Wrap child with error catching
    return _ErrorCatcher(onError: _handleError, child: widget.child);
  }

  void _handleError(Object error, StackTrace stackTrace) {
    setState(() {
      _error = error;
      _stackTrace = stackTrace;
    });

    // Log error
    AppLogger.error(
      'Error caught by ErrorBoundary',
      tag: widget.tag ?? 'ErrorBoundary',
      error: error,
      stackTrace: stackTrace,
    );

    // Report to Crashlytics
    if (widget.reportToCrashlytics) {
      CrashlyticsService.recordError(
        error,
        stackTrace,
        reason: 'ErrorBoundary caught error',
        information: {
          'tag': widget.tag ?? 'ErrorBoundary',
          'widgetType': widget.child.runtimeType.toString(),
        },
      );
    }

    // Call custom error handler
    widget.onError?.call(error, stackTrace);
  }

  void _retry() {
    setState(() {
      _error = null;
      _stackTrace = null;
    });
  }

  Widget _buildDefaultErrorUI(
    BuildContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    return ErrorBoundaryView(
      error: error,
      stackTrace: stackTrace,
      onRetry: _retry,
    );
  }
}

/// Internal widget for catching errors
class _ErrorCatcher extends StatelessWidget {
  final Widget child;
  final void Function(Object error, StackTrace stackTrace) onError;

  const _ErrorCatcher({required this.child, required this.onError});

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      onError(details.exception, details.stack ?? StackTrace.current);
      return const SizedBox.shrink();
    };

    return child;
  }
}

/// Default error UI displayed by ErrorBoundary
class ErrorBoundaryView extends StatelessWidget {
  final Object error;
  final StackTrace stackTrace;
  final VoidCallback? onRetry;
  final bool showDetails;

  const ErrorBoundaryView({
    super.key,
    required this.error,
    required this.stackTrace,
    this.onRetry,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),

              const SizedBox(height: 24),

              // Error title
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Error message
              Text(
                _getErrorMessage(error),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Retry button
              if (onRetry != null)
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),

              // Show details (debug mode only)
              if (showDetails) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => _showErrorDetails(context),
                  child: const Text('Show Details'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getErrorMessage(Object error) {
    if (error is Failure) {
      return error.userMessage;
    }
    return 'An unexpected error occurred. Please try again.';
  }

  void _showErrorDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Error:',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              Text(
                'Stack Trace:',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                stackTrace.toString(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Simplified error boundary for inline use
class InlineErrorBoundary extends StatelessWidget {
  final Widget child;
  final String? errorMessage;

  const InlineErrorBoundary({
    super.key,
    required this.child,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      errorBuilder: (error, stackTrace) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.errorContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  errorMessage ?? 'Failed to load content',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }
}

/// Error boundary specifically for async/future operations
class FutureErrorBoundary<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T data) builder;
  final Widget Function(Object error, StackTrace stackTrace)? errorBuilder;
  final Widget? loadingWidget;

  const FutureErrorBoundary({
    super.key,
    required this.future,
    required this.builder,
    this.errorBuilder,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error!;
          final stackTrace = snapshot.stackTrace ?? StackTrace.current;

          // Log error
          AppLogger.error(
            'FutureErrorBoundary caught error',
            error: error,
            stackTrace: stackTrace,
          );

          // Report to Crashlytics
          CrashlyticsService.recordError(
            error,
            stackTrace,
            reason: 'FutureErrorBoundary caught error',
          );

          if (errorBuilder != null) {
            return errorBuilder!(error, stackTrace);
          }

          return ErrorBoundaryView(error: error, stackTrace: stackTrace);
        }

        if (snapshot.hasData) {
          return builder(snapshot.data as T);
        }

        return loadingWidget ??
            const Center(child: CircularProgressIndicator());
      },
    );
  }
}

/// Extension for adding error boundaries to widgets
extension ErrorBoundaryExtension on Widget {
  /// Wrap this widget with an error boundary
  Widget withErrorBoundary({
    Widget Function(Object error, StackTrace stackTrace)? errorBuilder,
    void Function(Object error, StackTrace stackTrace)? onError,
    bool reportToCrashlytics = true,
    String? tag,
  }) {
    return ErrorBoundary(
      errorBuilder: errorBuilder,
      onError: onError,
      reportToCrashlytics: reportToCrashlytics,
      tag: tag,
      child: this,
    );
  }

  /// Wrap this widget with an inline error boundary
  Widget withInlineErrorBoundary({String? errorMessage}) {
    return InlineErrorBoundary(errorMessage: errorMessage, child: this);
  }
}
