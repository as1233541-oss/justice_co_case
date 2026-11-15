import '../entities/cases_result.dart';

abstract class CaseRepository {

  Future<CasesResult> getActiveCases();
}
