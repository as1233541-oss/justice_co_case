import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_format.dart';

class OfflineBanner extends StatelessWidget {
  final DateTime lastSynced;
  final VoidCallback onRetry;

  const OfflineBanner({
    super.key,
    required this.lastSynced,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.warningBg,
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, size: 18, color: AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Offline: showing saved data from ${formatDateTime(lastSynced)}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
