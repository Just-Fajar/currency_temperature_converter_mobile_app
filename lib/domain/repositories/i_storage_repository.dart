import '../core/result.dart';
import '../entities/conversion.dart';

/// Repository interface for storage operations.
///
/// Defines contract for persisting and retrieving data locally.
abstract class IStorageRepository {
  /// Save a conversion to history
  Future<Result<void>> saveConversion(Conversion conversion);

  /// Get all conversion history
  Future<Result<List<Conversion>>> getHistory({
    String? type,
    int? limit,
    int? offset,
  });

  /// Delete a conversion from history
  Future<Result<void>> deleteConversion(String id);

  /// Clear all conversion history
  Future<Result<void>> clearHistory();

  /// Save a preference value
  Future<Result<void>> savePreference(String key, dynamic value);

  /// Get a preference value
  Future<Result<dynamic>> getPreference(String key);

  /// Delete a preference
  Future<Result<void>> deletePreference(String key);

  /// Clear all preferences
  Future<Result<void>> clearPreferences();
}
