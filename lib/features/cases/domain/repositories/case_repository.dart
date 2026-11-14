import '../entities/case.dart';

abstract class CaseRepository {

  Future<List<Case>> getActiveCases();
}
