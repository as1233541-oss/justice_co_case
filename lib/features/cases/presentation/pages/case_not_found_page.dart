import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class CaseNotFoundPage extends StatelessWidget {
  const CaseNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Case not found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off, size: 64, color: AppColors.textGrey),
              const SizedBox(height: 16),
              const Text(
                'This case could not be opened. Please go back to the list and select it again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to cases'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
