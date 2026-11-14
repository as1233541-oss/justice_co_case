import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/case.dart';
import '../../domain/usecases/get_active_cases.dart';
import '../widgets/case_list_item.dart';
import '../widgets/error_view.dart';
import '../widgets/summary_header.dart';

class CasesPage extends StatefulWidget {
  final GetActiveCases getActiveCases;

  const CasesPage({super.key, required this.getActiveCases});

  @override
  State<CasesPage> createState() => _CasesPageState();
}

class _CasesPageState extends State<CasesPage> {
  late Future<List<Case>> _casesFuture;

  @override
  void initState() {
    super.initState();
    _casesFuture = widget.getActiveCases();
  }

  void _retry() {
    setState(() {
      _casesFuture = widget.getActiveCases();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Cases')),
      body: FutureBuilder<List<Case>>(
        future: _casesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.navy),
                  SizedBox(height: 16),
                  Text(
                    'Loading cases...',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error!, onRetry: _retry);
          }

          final cases = snapshot.data ?? <Case>[];
          if (cases.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.folder_open,
                      size: 64, color: AppColors.textGrey),
                  SizedBox(height: 12),
                  Text(
                    'No active cases found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              SummaryHeader(count: cases.length),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: cases.length,
                  itemBuilder: (context, index) =>
                      CaseListItem(caseItem: cases[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
