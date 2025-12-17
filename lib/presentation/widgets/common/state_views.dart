import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import 'buttons.dart';

/// Error view widget for displaying error states.
///
/// Shows an error icon, message, and optional retry button.
/// Provides consistent error UI across the application.
///
/// Example:
/// ```dart
/// ErrorView(
///   title: 'Connection Failed',
///   message: 'Unable to connect to server',
///   icon: Icons.wifi_off,
///   onRetry: () => fetchData(),
/// )
/// ```
class ErrorView extends StatelessWidget {
  /// Error title
  final String title;

  /// Error message/description
  final String message;

  /// Error icon
  final IconData icon;

  /// Retry callback
  final VoidCallback? onRetry;

  /// Optional additional action button
  final Widget? additionalAction;

  const ErrorView({
    super.key,
    this.title = 'Oops! Something went wrong',
    required this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.additionalAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: colorScheme.error),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 32),

            // Action buttons
            if (onRetry != null || additionalAction != null)
              Column(
                children: [
                  if (onRetry != null)
                    PrimaryButton(
                      label: 'Try Again',
                      icon: Icons.refresh,
                      onPressed: onRetry,
                    ),
                  if (additionalAction != null) ...[
                    const SizedBox(height: 12),
                    additionalAction!,
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Empty state view widget for displaying when no data is available.
///
/// Shows an icon, message, and optional action button.
/// Used for empty lists, search results, etc.
///
/// Example:
/// ```dart
/// EmptyView(
///   title: 'No History',
///   message: 'Your conversion history will appear here',
///   icon: Icons.history,
///   actionLabel: 'Convert Now',
///   onAction: () => navigateToConverter(),
/// )
/// ```
class EmptyView extends StatelessWidget {
  /// Empty state title
  final String title;

  /// Empty state message/description
  final String message;

  /// Icon to display
  final IconData icon;

  /// Optional action button label
  final String? actionLabel;

  /// Optional action button callback
  final VoidCallback? onAction;

  /// Icon color
  final Color? iconColor;

  const EmptyView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Icon(
              icon,
              size: 96,
              color: iconColor ?? colorScheme.outline.withValues(alpha: 0.5),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // Action button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              PrimaryButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error view for offline/connection errors
class NetworkErrorView extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorView({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ErrorView(
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }
}

/// Server error view for 500 errors
class ServerErrorView extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorView({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ErrorView(
      title: 'Server Error',
      message: 'Something went wrong on our end. Please try again later.',
      icon: Icons.cloud_off,
      onRetry: onRetry,
    );
  }
}

/// Not found error view for 404 errors
class NotFoundView extends StatelessWidget {
  final VoidCallback? onGoBack;

  const NotFoundView({super.key, this.onGoBack});

  @override
  Widget build(BuildContext context) {
    return ErrorView(
      title: 'Not Found',
      message: 'The content you are looking for could not be found.',
      icon: Icons.search_off,
      onRetry: onGoBack,
    );
  }
}

/// Empty search results view
class EmptySearchView extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClearSearch;

  const EmptySearchView({
    super.key,
    required this.searchQuery,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyView(
      title: 'No Results Found',
      message: 'No results found for "$searchQuery".\nTry different keywords.',
      icon: Icons.search_off,
      actionLabel: 'Clear Search',
      onAction: onClearSearch,
    );
  }
}

/// Empty history view
class EmptyHistoryView extends StatelessWidget {
  final VoidCallback? onStartConverting;

  const EmptyHistoryView({super.key, this.onStartConverting});

  @override
  Widget build(BuildContext context) {
    return EmptyView(
      title: 'No History Yet',
      message:
          'Your conversion history will appear here.\nStart converting to see your history.',
      icon: Icons.history,
      actionLabel: 'Convert Now',
      onAction: onStartConverting,
    );
  }
}

/// Loading view with spinner and message
class LoadingView extends StatelessWidget {
  final String? message;

  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact error message card (for inline errors)
class ErrorMessageCard extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final VoidCallback? onRetry;

  const ErrorMessageCard({
    super.key,
    required this.message,
    this.onDismiss,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.errorContainer,
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
            if (onRetry != null)
              IconButton(
                icon: const Icon(Icons.refresh),
                color: colorScheme.onErrorContainer,
                onPressed: onRetry,
              ),
            if (onDismiss != null)
              IconButton(
                icon: const Icon(Icons.close),
                color: colorScheme.onErrorContainer,
                onPressed: onDismiss,
              ),
          ],
        ),
      ),
    );
  }
}

/// Success message card (for inline success messages)
class SuccessMessageCard extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const SuccessMessageCard({super.key, required this.message, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.primaryContainer,
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            if (onDismiss != null)
              IconButton(
                icon: const Icon(Icons.close),
                color: colorScheme.onPrimaryContainer,
                onPressed: onDismiss,
              ),
          ],
        ),
      ),
    );
  }
}
