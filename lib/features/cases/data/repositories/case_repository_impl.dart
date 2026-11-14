
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/case.dart';
import '../../domain/repositories/case_repository.dart';
import '../datasources/case_remote_data_source.dart';

class CaseRepositoryImpl implements CaseRepository {
  final CaseRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const CaseRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Case>> getActiveCases() async {
    try {
      if (!await networkInfo.isConnected) {
        throw const NoInternetException();
      }

      final models = await remoteDataSource.fetchCases();

      return models.where((c) => c.status == 'active').toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to load cases: $e');
    }
  }
}
