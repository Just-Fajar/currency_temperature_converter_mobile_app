import 'conversion_history.dart';

/// Model for paginated history results
class PaginatedHistory {
  final List<ConversionHistory> items;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedHistory({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  int get totalPages => (totalCount / pageSize).ceil();
}
