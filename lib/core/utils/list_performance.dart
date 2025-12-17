import 'package:flutter/material.dart';

/// Performance optimization utilities for ListView and list-based widgets
///
/// Provides best practices for efficient list rendering including:
/// - Proper key usage for widget stability
/// - Item extent optimization
/// - Cache extent configuration
/// - Separator builders
class ListPerformance {
  /// Create an optimized ListView.builder with performance best practices
  ///
  /// Features:
  /// - Automatic key generation for stable widget tree
  /// - Optimized cache extent
  /// - Proper physics configuration
  ///
  /// Example:
  /// ```dart
  /// ListPerformance.builder(
  ///   itemCount: items.length,
  ///   itemBuilder: (context, index) => ItemWidget(items[index]),
  ///   keyBuilder: (index) => items[index].id,
  /// )
  /// ```
  static Widget builder({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    String Function(int)? keyBuilder,
    ScrollController? controller,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    double cacheExtent = 250.0,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool shrinkWrap = false,
  }) {
    return ListView.builder(
      controller: controller,
      physics: physics ?? const BouncingScrollPhysics(),
      padding: padding,
      itemCount: itemCount,
      itemExtent: itemExtent,
      cacheExtent: cacheExtent,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        final key = keyBuilder != null
            ? ValueKey(keyBuilder(index))
            : ValueKey(index);

        return KeyedSubtree(key: key, child: itemBuilder(context, index));
      },
    );
  }

  /// Create an optimized ListView.separated
  ///
  /// Automatically adds keys and optimizes performance for separated lists.
  ///
  /// Example:
  /// ```dart
  /// ListPerformance.separated(
  ///   itemCount: items.length,
  ///   itemBuilder: (context, index) => ItemWidget(items[index]),
  ///   separatorBuilder: (context, index) => const Divider(),
  ///   keyBuilder: (index) => items[index].id,
  /// )
  /// ```
  static Widget separated({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    required Widget Function(BuildContext, int) separatorBuilder,
    String Function(int)? keyBuilder,
    ScrollController? controller,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    double cacheExtent = 250.0,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool shrinkWrap = false,
  }) {
    return ListView.separated(
      controller: controller,
      physics: physics ?? const BouncingScrollPhysics(),
      padding: padding,
      itemCount: itemCount,
      cacheExtent: cacheExtent,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        final key = keyBuilder != null
            ? ValueKey(keyBuilder(index))
            : ValueKey(index);

        return KeyedSubtree(key: key, child: itemBuilder(context, index));
      },
      separatorBuilder: separatorBuilder,
    );
  }

  /// Create a GridView.builder with performance optimizations
  ///
  /// Example:
  /// ```dart
  /// ListPerformance.grid(
  ///   itemCount: items.length,
  ///   crossAxisCount: 2,
  ///   itemBuilder: (context, index) => GridItemWidget(items[index]),
  ///   keyBuilder: (index) => items[index].id,
  /// )
  /// ```
  static Widget grid({
    required int itemCount,
    required int crossAxisCount,
    required Widget Function(BuildContext, int) itemBuilder,
    String Function(int)? keyBuilder,
    ScrollController? controller,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    double mainAxisSpacing = 8.0,
    double crossAxisSpacing = 8.0,
    double childAspectRatio = 1.0,
    double cacheExtent = 250.0,
    bool shrinkWrap = false,
  }) {
    return GridView.builder(
      controller: controller,
      physics: physics ?? const BouncingScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      cacheExtent: cacheExtent,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        final key = keyBuilder != null
            ? ValueKey(keyBuilder(index))
            : ValueKey(index);

        return KeyedSubtree(key: key, child: itemBuilder(context, index));
      },
    );
  }

  /// Wrap a list item with repaint boundary for better performance
  ///
  /// Use this for complex list items to isolate repaints.
  ///
  /// Example:
  /// ```dart
  /// ListPerformance.optimizedItem(
  ///   child: ComplexItemWidget(data),
  /// )
  /// ```
  static Widget optimizedItem({required Widget child, Key? key}) {
    return RepaintBoundary(key: key, child: child);
  }

  /// Create a sliver list with performance optimizations
  ///
  /// For use with CustomScrollView.
  ///
  /// Example:
  /// ```dart
  /// CustomScrollView(
  ///   slivers: [
  ///     ListPerformance.sliverList(
  ///       itemCount: items.length,
  ///       itemBuilder: (context, index) => ItemWidget(items[index]),
  ///     ),
  ///   ],
  /// )
  /// ```
  static Widget sliverList({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    String Function(int)? keyBuilder,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
  }) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final key = keyBuilder != null
              ? ValueKey(keyBuilder(index))
              : ValueKey(index);

          return KeyedSubtree(key: key, child: itemBuilder(context, index));
        },
        childCount: itemCount,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
      ),
    );
  }

  /// Calculate optimal cache extent based on item count and screen size
  ///
  /// Returns a reasonable cache extent value for smooth scrolling.
  static double calculateCacheExtent(
    BuildContext context,
    int itemCount, {
    double itemHeight = 80.0,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Cache 2x screen height or max 10 items, whichever is larger
    final baseCache = screenHeight * 2;
    final itemsCache = itemHeight * 10;

    return baseCache > itemsCache ? baseCache : itemsCache;
  }
}
