import '../core/result.dart';
import '../entities/conversion.dart';
import '../repositories/i_storage_repository.dart';
import 'usecase.dart';

/// Use case for saving conversion to history.
///
/// Handles:
/// - Validation
/// - Storage persistence
/// - History size management
///
/// Example:
/// ```dart
/// final useCase = SaveConversionUseCase(storageRepository);
/// final result = await useCase(conversion);
/// ```
class SaveConversionUseCase implements UseCase<Result<void>, Conversion> {
  final IStorageRepository _repository;

  SaveConversionUseCase(this._repository);

  @override
  Future<Result<void>> call(Conversion params) async {
    return await _repository.saveConversion(params);
  }
}
