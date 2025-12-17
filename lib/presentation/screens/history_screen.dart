import 'package:flutter/material.dart';

import '../../core/utils/responsive_helper.dart';
import '../../data/models/conversion_history.dart';
import '../../data/repositories/storage_repository.dart';
import '../widgets/history_tile.dart';

/// Conversion history screen with search, sort, and tap-to-reuse
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageRepository _storage = StorageRepository();
  final TextEditingController _searchController = TextEditingController();
  String _filter = 'all'; // 'all', 'currency', 'temperature'
  String _sortBy = 'date'; // 'date', 'type'
  String _searchQuery = '';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initStorage();
  }

  Future<void> _initStorage() async {
    await _storage.init();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversion History'),
        actions: [
          // Sort menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 20,
                      color: _sortBy == 'date'
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Sort by Date'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'type',
                child: Row(
                  children: [
                    Icon(
                      Icons.category,
                      size: 20,
                      color: _sortBy == 'type'
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Sort by Type'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<ConversionHistory>>(
              future: _getHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var history = snapshot.data ?? [];

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  history = history.where((item) {
                    final query = _searchQuery.toLowerCase();
                    return item.fromUnit.toLowerCase().contains(query) ||
                        item.toUnit.toLowerCase().contains(query) ||
                        item.inputValue.toString().contains(query) ||
                        item.result.toString().contains(query);
                  }).toList();
                }

                // Apply sort
                if (_sortBy == 'date') {
                  history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
                } else {
                  history.sort((a, b) => a.type.compareTo(b.type));
                }

                if (history.isEmpty && _searchQuery.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No conversion history',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start converting to see your history',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                if (history.isEmpty && _searchQuery.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search query',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: EdgeInsets.all(
                        ResponsiveHelper.getPadding(context),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search conversions...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),

                    // Filter chips
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getPadding(context),
                      ),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('All'),
                            selected: _filter == 'all',
                            onSelected: (_) {
                              setState(() {
                                _filter = 'all';
                              });
                            },
                          ),
                          FilterChip(
                            label: const Text('Currency'),
                            selected: _filter == 'currency',
                            onSelected: (_) {
                              setState(() {
                                _filter = 'currency';
                              });
                            },
                          ),
                          FilterChip(
                            label: const Text('Temperature'),
                            selected: _filter == 'temperature',
                            onSelected: (_) {
                              setState(() {
                                _filter = 'temperature';
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // History list with slide animation
                    Expanded(
                      child: ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(
                              milliseconds: 300 + (index * 50),
                            ),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(50 * (1 - value), 0),
                                child: Opacity(opacity: value, child: child),
                              );
                            },
                            child: Dismissible(
                              key: Key('history_${history[index].timestamp}'),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) async {
                                await _storage.deleteConversion(index);
                                setState(() {});
                              },
                              child: HistoryTile(
                                history: history[index],
                                onTap: () => _reuseConversion(history[index]),
                                onDelete: () async {
                                  await _storage.deleteConversion(index);
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Clear History'),
              content: const Text(
                'Are you sure you want to clear all conversion history?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Clear'),
                ),
              ],
            ),
          );

          if (confirm == true && mounted) {
            await _storage.clearHistory();
            setState(() {});
          }
        },
        icon: const Icon(Icons.delete_sweep),
        label: const Text('Clear All'),
      ),
    );
  }

  Future<List<ConversionHistory>> _getHistory() async {
    if (_filter == 'all') {
      return await _storage.getHistory();
    } else {
      return await _storage.getHistoryByType(_filter);
    }
  }

  void _reuseConversion(ConversionHistory history) {
    // Navigate back to home and pass the conversion data
    Navigator.pop(context, {
      'type': history.type,
      'fromUnit': history.fromUnit,
      'toUnit': history.toUnit,
      'value': history.inputValue.toString(),
    });

    // Show a snackbar to confirm
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Loaded ${history.type} conversion: ${history.fromUnit} to ${history.toUnit}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
