import 'package:flutter/material.dart';

/// Optimization utilities for selective widget rebuilds
///
/// These utilities help minimize unnecessary widget rebuilds,
/// improving app performance by rebuilding only what's needed.
class BuildOptimization {
  /// Wrap a widget with selective rebuild capability
  ///
  /// Only rebuilds child when [shouldRebuild] returns true.
  ///
  /// Example:
  /// ```dart
  /// BuildOptimization.selective<MyData>(
  ///   selector: (context, data) => data.count,
  ///   shouldRebuild: (previous, current) => previous != current,
  ///   builder: (context, value, child) => Text('$value'),
  /// )
  /// ```
  static Widget selective<T>({
    required T Function(BuildContext, T) selector,
    required bool Function(T previous, T current) shouldRebuild,
    required Widget Function(BuildContext, T, Widget?) builder,
    Widget? child,
  }) {
    return _SelectiveBuilder<T>(
      selector: selector,
      shouldRebuild: shouldRebuild,
      builder: builder,
      child: child,
    );
  }

  /// Create a const child wrapper to prevent rebuilds
  ///
  /// Wrap static content that never changes to prevent rebuilds.
  ///
  /// Example:
  /// ```dart
  /// Consumer<MyProvider>(
  ///   builder: (context, provider, child) {
  ///     return Column(
  ///       children: [
  ///         child!, // Static content never rebuilds
  ///         Text(provider.dynamicData),
  ///       ],
  ///     );
  ///   },
  ///   child: BuildOptimization.staticChild(
  ///     const Text('Static Header'),
  ///   ),
  /// )
  /// ```
  static Widget staticChild(Widget child) {
    return _StaticChildWrapper(child: child);
  }

  /// Memoize expensive computations
  ///
  /// Cache computation results to avoid recalculating.
  ///
  /// Example:
  /// ```dart
  /// final expensiveResult = BuildOptimization.memoize(
  ///   key: 'calculation_$input',
  ///   compute: () => performExpensiveCalculation(input),
  /// );
  /// ```
  static T memoize<T>({required String key, required T Function() compute}) {
    return _MemoizationCache.get<T>(key, compute);
  }

  /// Clear memoization cache
  static void clearCache() {
    _MemoizationCache.clear();
  }
}

/// Internal widget for selective rebuilds
class _SelectiveBuilder<T> extends StatefulWidget {
  final T Function(BuildContext, T) selector;
  final bool Function(T previous, T current) shouldRebuild;
  final Widget Function(BuildContext, T, Widget?) builder;
  final Widget? child;

  const _SelectiveBuilder({
    required this.selector,
    required this.shouldRebuild,
    required this.builder,
    this.child,
  });

  @override
  State<_SelectiveBuilder<T>> createState() => _SelectiveBuilderState<T>();
}

class _SelectiveBuilderState<T> extends State<_SelectiveBuilder<T>> {
  late T _value;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newValue = widget.selector(context, _value);
    if (!mounted) {
      _value = newValue;
      return;
    }

    if (widget.shouldRebuild(_value, newValue)) {
      setState(() {
        _value = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value, widget.child);
  }
}

/// Wrapper for static child content
class _StaticChildWrapper extends StatelessWidget {
  final Widget child;

  const _StaticChildWrapper({required this.child});

  @override
  Widget build(BuildContext context) => child;
}

/// Simple memoization cache
class _MemoizationCache {
  static final Map<String, dynamic> _cache = {};

  static T get<T>(String key, T Function() compute) {
    if (_cache.containsKey(key)) {
      return _cache[key] as T;
    }

    final result = compute();
    _cache[key] = result;
    return result;
  }

  static void clear() {
    _cache.clear();
  }

  // ignore: unused_element
  static void _remove(String key) {
    _cache.remove(key);
  }
}
