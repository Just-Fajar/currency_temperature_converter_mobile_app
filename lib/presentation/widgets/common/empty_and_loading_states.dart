import 'package:flutter/material.dart';

import '../../../core/animations/animation_utils.dart';
import '../../../core/design_system/ds_spacing.dart';
import '../../../core/design_system/ds_typography.dart';

/// Empty state widget for displaying when no data is available.
///
/// Provides consistent empty state UI across the application.
///
/// Example:
/// ```dart
/// EmptyStateWidget(
///   icon: Icons.history,
///   title: 'No History',
///   message: 'Your conversion history will appear here',
///   actionLabel: 'Convert Now',
///   onAction: () => navigateToConverter(),
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: DSSpacing.paddingXXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(DSSpacing.xxl),
              decoration: BoxDecoration(
                color: (iconColor ?? Theme.of(context).colorScheme.primary)
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor ?? Theme.of(context).colorScheme.primary,
              ),
            ).fadeIn().scaleIn(),

            SizedBox(height: DSSpacing.xxl),

            // Title
            Text(
              title,
              style: DSTypography.headlineSmall(context),
              textAlign: TextAlign.center,
            ).fadeIn(delay: const Duration(milliseconds: 100)),

            SizedBox(height: DSSpacing.md),

            // Message
            Text(
              message,
              style: DSTypography.bodyMedium(
                context,
              ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ).fadeIn(delay: const Duration(milliseconds: 200)),

            // Action button
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: DSSpacing.xxl),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ).fadeIn(delay: const Duration(milliseconds: 300)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty history state
class EmptyHistoryState extends StatelessWidget {
  final VoidCallback? onStartConverting;

  const EmptyHistoryState({super.key, this.onStartConverting});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.history,
      title: 'No History Yet',
      message:
          'Your conversion history will appear here once you start converting currencies or temperatures',
      actionLabel: 'Start Converting',
      onAction: onStartConverting,
    );
  }
}

/// Empty search results state
class EmptySearchState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClearSearch;

  const EmptySearchState({
    super.key,
    required this.searchQuery,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No Results Found',
      message:
          'No results found for "$searchQuery".\nTry a different search term.',
      actionLabel: 'Clear Search',
      onAction: onClearSearch,
    );
  }
}

/// Empty favorites state
class EmptyFavoritesState extends StatelessWidget {
  final VoidCallback? onBrowse;

  const EmptyFavoritesState({super.key, this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'No Favorites',
      message:
          'You haven\'t added any favorites yet.\nSave your favorite conversions for quick access.',
      actionLabel: 'Browse Conversions',
      onAction: onBrowse,
    );
  }
}

/// No internet connection state
class NoInternetState extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetState({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.wifi_off,
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      actionLabel: 'Retry',
      onAction: onRetry,
      iconColor: Theme.of(context).colorScheme.error,
    );
  }
}

/// Loading state widget with various styles
class LoadingStateWidget extends StatelessWidget {
  final String? message;
  final LoadingStyle style;
  final Color? color;

  const LoadingStateWidget({
    super.key,
    this.message,
    this.style = LoadingStyle.circular,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: DSSpacing.paddingXXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLoader(context),
            if (message != null) ...[
              SizedBox(height: DSSpacing.lg),
              Text(
                message!,
                style: DSTypography.bodyMedium(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoader(BuildContext context) {
    final loaderColor = color ?? Theme.of(context).colorScheme.primary;

    switch (style) {
      case LoadingStyle.circular:
        return CircularProgressIndicator(color: loaderColor);
      case LoadingStyle.linear:
        return SizedBox(
          width: 200,
          child: LinearProgressIndicator(color: loaderColor),
        );
      case LoadingStyle.dots:
        return _DotsLoader(color: loaderColor);
      case LoadingStyle.pulse:
        return _PulseLoader(color: loaderColor);
    }
  }
}

/// Loading style enum
enum LoadingStyle { circular, linear, dots, pulse }

/// Dots loader animation
class _DotsLoader extends StatefulWidget {
  final Color color;

  const _DotsLoader({required this.color});

  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = (_controller.value + delay) % 1.0;
            final scale = 0.5 + (0.5 * (1 - (value - 0.5).abs() * 2));

            return Transform.scale(
              scale: scale,
              child: Container(
                width: 12,
                height: 12,
                margin: EdgeInsets.symmetric(horizontal: DSSpacing.xs),
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Pulse loader animation
class _PulseLoader extends StatelessWidget {
  final Color color;

  const _PulseLoader({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: PulseAnimation(
        child: Container(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

/// Inline loading indicator for smaller spaces
class InlineLoadingIndicator extends StatelessWidget {
  final String? label;
  final double size;
  final Color? color;

  const InlineLoadingIndicator({
    super.key,
    this.label,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        if (label != null) ...[
          SizedBox(width: DSSpacing.sm),
          Text(label!, style: DSTypography.bodySmall(context)),
        ],
      ],
    );
  }
}

/// Skeleton loader for content placeholders
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  /// Rectangle skeleton
  const SkeletonLoader.rectangle({
    super.key,
    required this.width,
    required this.height,
  }) : borderRadius = DSBorderRadius.borderRadiusSM;

  /// Circle skeleton
  SkeletonLoader.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = BorderRadius.circular(size / 2);

  /// Text line skeleton
  const SkeletonLoader.text({super.key, double? width, this.height = 14})
    : width = width ?? double.infinity,
      borderRadius = DSBorderRadius.borderRadiusXS;

  @override
  Widget build(BuildContext context) {
    return ShimmerAnimation(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// List skeleton loader
class ListSkeletonLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ListSkeletonLoader({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: DSSpacing.sm),
      itemBuilder: (context, index) {
        return Container(
          height: itemHeight,
          padding: DSSpacing.paddingLG,
          child: Row(
            children: [
              SkeletonLoader.circle(size: 48),
              SizedBox(width: DSSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonLoader.text(width: double.infinity),
                    SizedBox(height: DSSpacing.sm),
                    SkeletonLoader.text(width: 150),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Card skeleton loader
class CardSkeletonLoader extends StatelessWidget {
  final double height;

  const CardSkeletonLoader({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: height,
        padding: DSSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader.text(width: 200),
            SizedBox(height: DSSpacing.md),
            SkeletonLoader.text(width: double.infinity),
            SizedBox(height: DSSpacing.sm),
            SkeletonLoader.text(width: double.infinity),
            const Spacer(),
            Row(
              children: [
                SkeletonLoader.rectangle(width: 80, height: 36),
                SizedBox(width: DSSpacing.sm),
                SkeletonLoader.rectangle(width: 80, height: 36),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
