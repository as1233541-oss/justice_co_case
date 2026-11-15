import '../entities/cases_result.dart';
import '../repositories/case_repository.dart';

class GetActiveCases {
  final CaseRepository repository;

  const GetActiveCases(this.repository);

  Future<CasesResult> call() => repository.getActiveCases();
}
