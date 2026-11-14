import '../entities/case.dart';
import '../repositories/case_repository.dart';

class GetActiveCases {
  final CaseRepository repository;

  const GetActiveCases(this.repository);

  Future<List<Case>> call() => repository.getActiveCases();
}
