import '../core/result.dart';
import '../entities/conversion.dart';
import '../repositories/i_storage_repository.dart';
import 'usecase.dart';

/// Use case for getting conversion history.
///
/// Handles:
/// - History retrieval
/// - Filtering by type
/// - Pagination
///
/// Example:
/// ```dart
/// final useCase = GetConversionHistoryUseCase(storageRepository);
/// final result = await useCase(GetHistoryParams(
///   type: 'currency',
///   limit: 20,
/// ));
/// ```
class GetConversionHistoryUseCase
    implements UseCase<Result<List<Conversion>>, GetHistoryParams> {
  final IStorageRepository _repository;

  GetConversionHistoryUseCase(this._repository);

  @override
  Future<Result<List<Conversion>>> call(GetHistoryParams params) async {
    return await _repository.getHistory(
      type: params.type,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

/// Parameters for getting history
class GetHistoryParams {
  final String? type;
  final int? limit;
  final int? offset;

  const GetHistoryParams({this.type, this.limit, this.offset});
}
