
import 'package:go_router/go_router.dart';

import 'features/cases/domain/entities/case.dart';
import 'features/cases/domain/usecases/add_note.dart';
import 'features/cases/domain/usecases/get_active_cases.dart';
import 'features/cases/domain/usecases/get_notes.dart';
import 'features/cases/presentation/pages/case_detail_page.dart';
import 'features/cases/presentation/pages/case_not_found_page.dart';
import 'features/cases/presentation/pages/cases_page.dart';

GoRouter createRouter({
  required GetActiveCases getActiveCases,
  required GetNotes getNotes,
  required AddNote addNote,
}) {
  return GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => const CaseNotFoundPage(),
    routes: [
      GoRoute(
        path: '/',
        name: 'cases',
        builder: (context, state) => CasesPage(getActiveCases: getActiveCases),
      ),
      GoRoute(
        path: '/cases/:id',
        name: 'caseDetail',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Case) {
            return CaseDetailPage(
              caseItem: extra,
              getNotes: getNotes,
              addNote: addNote,
            );
          }
          return const CaseNotFoundPage();
        },
      ),
    ],
  );
}
