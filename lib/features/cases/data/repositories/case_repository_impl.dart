
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/case.dart';
import '../../domain/entities/cases_result.dart';
import '../../domain/repositories/case_repository.dart';
import '../datasources/case_local_data_source.dart';
import '../datasources/case_remote_data_source.dart';
import '../models/case_model.dart';

class CaseRepositoryImpl implements CaseRepository {
  final CaseRemoteDataSource remoteDataSource;
  final CaseLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const CaseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<CasesResult> getActiveCases() async {
    try {
      if (!await networkInfo.isConnected) {
        throw const NoInternetException();
      }

      final models = await remoteDataSource.fetchCases();
      await _updateCache(models);

      return CasesResult(
        cases: _onlyActive(models),
        fromCache: false,
        lastSynced: DateTime.now(),
      );
    } on AppException catch (apiError) {
      return _loadFromCache(apiError);
    } catch (e) {
      return _loadFromCache(UnknownException('Failed to load cases: $e'));
    }
  }

  Future<void> _updateCache(List<CaseModel> models) async {
    try {
      await localDataSource.cacheCases(models);
    } catch (_) {}
  }

  Future<CasesResult> _loadFromCache(AppException apiError) async {
    try {
      final cached = await localDataSource.getCachedCases();
      return CasesResult(
        cases: _onlyActive(cached.cases),
        fromCache: true,
        lastSynced: cached.savedAt,
      );
    } on CacheException {
      throw apiError;
    }
  }

  List<Case> _onlyActive(List<CaseModel> models) =>
      models.where((c) => c.status == 'active').toList();
}
