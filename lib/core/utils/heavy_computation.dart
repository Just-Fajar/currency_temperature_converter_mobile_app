import 'package:flutter/foundation.dart';

import '../../data/models/conversion_history.dart';

/// Heavy computation utilities using isolates for background processing
///
/// These utilities offload CPU-intensive tasks to background isolates,
/// preventing UI jank and maintaining smooth 60fps performance.
///
/// All methods use Flutter's [compute] function which automatically
/// manages isolate lifecycle and communication.
class HeavyComputation {
  /// Process large history data in background isolate
  ///
  /// Performs expensive operations on history data without blocking UI:
  /// - Filtering
  /// - Sorting
  /// - Aggregation
  /// - Statistics calculation
  ///
  /// Example:
  /// ```dart
  /// final processed = await HeavyComputation.processHistory(
  ///   historyList,
  ///   ProcessHistoryParams(
  ///     filterType: 'currency',
  ///     sortBy: 'date',
  ///     calculateStats: true,
  ///   ),
  /// );
  /// ```
  static Future<ProcessedHistoryResult> processHistory(
    List<ConversionHistory> history,
    ProcessHistoryParams params,
  ) async {
    return await compute(_processHistoryInBackground, {
      'history': history,
      'params': params,
    });
  }

  /// Calculate statistics from conversion history in background
  ///
  /// Computes:
  /// - Total conversions
  /// - Average amount
  /// - Most used currencies
  /// - Conversion trends
  ///
  /// Example:
  /// ```dart
  /// final stats = await HeavyComputation.calculateStatistics(historyList);
  /// print('Total: ${stats.totalConversions}');
  /// print('Average: ${stats.averageAmount}');
  /// ```
  static Future<HistoryStatistics> calculateStatistics(
    List<ConversionHistory> history,
  ) async {
    return await compute(_calculateStatisticsInBackground, history);
  }

  /// Search through large history dataset in background
  ///
  /// Performs fuzzy search on:
  /// - Currency codes
  /// - Amounts
  /// - Dates
  ///
  /// Example:
  /// ```dart
  /// final results = await HeavyComputation.searchHistory(
  ///   historyList,
  ///   'USD',
  /// );
  /// ```
  static Future<List<ConversionHistory>> searchHistory(
    List<ConversionHistory> history,
    String query,
  ) async {
    return await compute(_searchHistoryInBackground, {
      'history': history,
      'query': query,
    });
  }

  /// Export history to CSV format in background
  ///
  /// Generates CSV string from history data without blocking UI.
  ///
  /// Example:
  /// ```dart
  /// final csv = await HeavyComputation.exportToCSV(historyList);
  /// await File('history.csv').writeAsString(csv);
  /// ```
  static Future<String> exportToCSV(List<ConversionHistory> history) async {
    return await compute(_exportToCSVInBackground, history);
  }

  /// Sort large datasets in background
  ///
  /// Available sort options:
  /// - date
  /// - amount
  /// - fromCurrency
  /// - toCurrency
  ///
  /// Example:
  /// ```dart
  /// final sorted = await HeavyComputation.sortHistory(
  ///   historyList,
  ///   sortBy: 'date',
  ///   ascending: false,
  /// );
  /// ```
  static Future<List<ConversionHistory>> sortHistory(
    List<ConversionHistory> history, {
    required String sortBy,
    bool ascending = true,
  }) async {
    return await compute(_sortHistoryInBackground, {
      'history': history,
      'sortBy': sortBy,
      'ascending': ascending,
    });
  }

  // ==================== Background Processing Functions ====================

  /// Background function for processing history
  static ProcessedHistoryResult _processHistoryInBackground(
    Map<String, dynamic> data,
  ) {
    final history = data['history'] as List<ConversionHistory>;
    final params = data['params'] as ProcessHistoryParams;

    // Filter by type if specified
    var filtered = history;
    if (params.filterType != null) {
      filtered = history.where((h) => h.type == params.filterType).toList();
    }

    // Sort if specified
    if (params.sortBy != null) {
      filtered = _sortList(filtered, params.sortBy!, params.ascending);
    }

    // Calculate statistics if requested
    HistoryStatistics? stats;
    if (params.calculateStats) {
      stats = _calculateStats(filtered);
    }

    return ProcessedHistoryResult(
      items: filtered,
      statistics: stats,
      totalProcessed: history.length,
      filteredCount: filtered.length,
    );
  }

  /// Background function for calculating statistics
  static HistoryStatistics _calculateStatisticsInBackground(
    List<ConversionHistory> history,
  ) {
    return _calculateStats(history);
  }

  /// Background function for searching history
  static List<ConversionHistory> _searchHistoryInBackground(
    Map<String, dynamic> data,
  ) {
    final history = data['history'] as List<ConversionHistory>;
    final query = (data['query'] as String).toLowerCase();

    return history.where((h) {
      return h.fromUnit.toLowerCase().contains(query) ||
          h.toUnit.toLowerCase().contains(query) ||
          h.inputValue.toString().contains(query) ||
          h.result.toString().contains(query);
    }).toList();
  }

  /// Background function for CSV export
  static String _exportToCSVInBackground(List<ConversionHistory> history) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('Date,Type,From,To,Amount,Result,Rate');

    // Data rows
    for (final item in history) {
      buffer.writeln(
        '${item.timestamp},${item.type},${item.fromUnit},'
        '${item.toUnit},${item.inputValue},${item.result},${item.exchangeRate}',
      );
    }

    return buffer.toString();
  }

  /// Background function for sorting
  static List<ConversionHistory> _sortHistoryInBackground(
    Map<String, dynamic> data,
  ) {
    final history = data['history'] as List<ConversionHistory>;
    final sortBy = data['sortBy'] as String;
    final ascending = data['ascending'] as bool;

    return _sortList(history, sortBy, ascending);
  }

  // ==================== Helper Functions ====================

  static List<ConversionHistory> _sortList(
    List<ConversionHistory> list,
    String sortBy,
    bool ascending,
  ) {
    final sorted = List<ConversionHistory>.from(list);

    sorted.sort((a, b) {
      int comparison;

      switch (sortBy) {
        case 'date':
          comparison = a.timestamp.compareTo(b.timestamp);
          break;
        case 'amount':
          comparison = a.inputValue.compareTo(b.inputValue);
          break;
        case 'fromCurrency':
          comparison = a.fromUnit.compareTo(b.fromUnit);
          break;
        case 'toCurrency':
          comparison = a.toUnit.compareTo(b.toUnit);
          break;
        default:
          comparison = 0;
      }

      return ascending ? comparison : -comparison;
    });

    return sorted;
  }

  static HistoryStatistics _calculateStats(List<ConversionHistory> history) {
    if (history.isEmpty) {
      return HistoryStatistics(
        totalConversions: 0,
        averageAmount: 0.0,
        mostUsedFromCurrency: '',
        mostUsedToCurrency: '',
        currencyConversions: 0,
        temperatureConversions: 0,
      );
    }

    // Calculate totals
    final totalConversions = history.length;
    final averageAmount =
        history.map((h) => h.inputValue).reduce((a, b) => a + b) /
        totalConversions;

    // Count currency usage
    final fromCurrencyCounts = <String, int>{};
    final toCurrencyCounts = <String, int>{};
    var currencyCount = 0;
    var temperatureCount = 0;

    for (final item in history) {
      // Count by type
      if (item.type == 'currency') {
        currencyCount++;
      } else {
        temperatureCount++;
      }

      // Count currency usage
      fromCurrencyCounts[item.fromUnit] =
          (fromCurrencyCounts[item.fromUnit] ?? 0) + 1;
      toCurrencyCounts[item.toUnit] = (toCurrencyCounts[item.toUnit] ?? 0) + 1;
    }

    // Find most used currencies
    final mostUsedFrom = fromCurrencyCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    final mostUsedTo = toCurrencyCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return HistoryStatistics(
      totalConversions: totalConversions,
      averageAmount: averageAmount,
      mostUsedFromCurrency: mostUsedFrom,
      mostUsedToCurrency: mostUsedTo,
      currencyConversions: currencyCount,
      temperatureConversions: temperatureCount,
    );
  }
}

// ==================== Data Classes ====================

/// Parameters for history processing
class ProcessHistoryParams {
  final String? filterType;
  final String? sortBy;
  final bool ascending;
  final bool calculateStats;

  const ProcessHistoryParams({
    this.filterType,
    this.sortBy,
    this.ascending = true,
    this.calculateStats = false,
  });
}

/// Result of history processing
class ProcessedHistoryResult {
  final List<ConversionHistory> items;
  final HistoryStatistics? statistics;
  final int totalProcessed;
  final int filteredCount;

  const ProcessedHistoryResult({
    required this.items,
    this.statistics,
    required this.totalProcessed,
    required this.filteredCount,
  });
}

/// Statistics calculated from history
class HistoryStatistics {
  final int totalConversions;
  final double averageAmount;
  final String mostUsedFromCurrency;
  final String mostUsedToCurrency;
  final int currencyConversions;
  final int temperatureConversions;

  const HistoryStatistics({
    required this.totalConversions,
    required this.averageAmount,
    required this.mostUsedFromCurrency,
    required this.mostUsedToCurrency,
    required this.currencyConversions,
    required this.temperatureConversions,
  });

  @override
  String toString() {
    return 'HistoryStatistics('
        'total: $totalConversions, '
        'avg: ${averageAmount.toStringAsFixed(2)}, '
        'from: $mostUsedFromCurrency, '
        'to: $mostUsedToCurrency'
        ')';
  }
}
