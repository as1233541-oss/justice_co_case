
import 'case.dart';

class CasesResult {
  final List<Case> cases;
  final bool fromCache;
  final DateTime lastSynced;

  const CasesResult({
    required this.cases,
    required this.fromCache,
    required this.lastSynced,
  });
}
