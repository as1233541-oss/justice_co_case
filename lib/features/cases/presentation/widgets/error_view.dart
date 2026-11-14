import 'package:flutter/material.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/theme/app_colors.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final e = error;
    final IconData icon;
    final String title;

    if (e is NoInternetException || e is RequestTimeoutException) {
      icon = Icons.wifi_off;
      title = 'No Internet Connection';
    } else if (e is ServerException) {
      icon = Icons.cloud_off;
      title = 'Server Error';
    } else if (e is DataParsingException) {
      icon = Icons.error_outline;
      title = 'Invalid Data Received';
    } else {
      icon = Icons.error_outline;
      title = 'Failed to Load';
    }
    final detail = e is AppException ? e.message : e.toString();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.redBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.red, size: 64),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
