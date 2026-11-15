import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'app_router.dart';
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'core/theme/app_colors.dart';
import 'features/cases/data/datasources/case_local_data_source.dart';
import 'features/cases/data/datasources/case_remote_data_source.dart';
import 'features/cases/data/datasources/note_local_data_source.dart';
import 'features/cases/data/repositories/case_repository_impl.dart';
import 'features/cases/data/repositories/note_repository_impl.dart';
import 'features/cases/domain/usecases/add_note.dart';
import 'features/cases/domain/usecases/get_active_cases.dart';
import 'features/cases/domain/usecases/get_notes.dart';


const String _casesBoxName = 'cases_cache';
const String _notesBoxName = 'case_notes';
Future<Box<String>> _openBox(String name) async {
  try {
    return await Hive.openBox<String>(name);
  } catch (_) {
    await Hive.deleteBoxFromDisk(name);
    return Hive.openBox<String>(name);
  }
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final cacheBox = await _openBox(_casesBoxName);
  final notesBox = await _openBox(_notesBoxName);
  final apiClient = ApiClient(client: http.Client());
  final remoteDataSource = CaseRemoteDataSourceImpl(apiClient: apiClient);
  final localDataSource = CaseLocalDataSourceImpl(cacheBox);
  final repository = CaseRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: NetworkInfoImpl(Connectivity()),
  );
  final getActiveCases = GetActiveCases(repository);
  final noteRepository = NoteRepositoryImpl(NoteLocalDataSourceImpl(notesBox));
  final router = createRouter(
    getActiveCases: getActiveCases,
    getNotes: GetNotes(noteRepository),
    addNote: AddNote(noteRepository),
  );
  runApp(JusticeCoApp(router: router));
}
class JusticeCoApp extends StatelessWidget {
  final GoRouter router;
  const JusticeCoApp({super.key, required this.router});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Justice & Co. Case Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.navy,
          primary: AppColors.navy,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}
