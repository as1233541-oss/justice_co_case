import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'core/theme/app_colors.dart';
import 'features/cases/data/datasources/case_remote_data_source.dart';
import 'features/cases/data/repositories/case_repository_impl.dart';
import 'features/cases/domain/usecases/get_active_cases.dart';
import 'features/cases/presentation/pages/cases_page.dart';

void main() {
  final apiClient = ApiClient(client: http.Client());
  final dataSource = CaseRemoteDataSourceImpl(apiClient: apiClient);
  final repository = CaseRepositoryImpl(
    remoteDataSource: dataSource,
    networkInfo: NetworkInfoImpl(Connectivity()),
  );
  final getActiveCases = GetActiveCases(repository);
  runApp(JusticeCoApp(getActiveCases: getActiveCases));
}
class JusticeCoApp extends StatelessWidget {
  final GetActiveCases getActiveCases;
  const JusticeCoApp({super.key, required this.getActiveCases});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: CasesPage(getActiveCases: getActiveCases),
    );
  }
}
