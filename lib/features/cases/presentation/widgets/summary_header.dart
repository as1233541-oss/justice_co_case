import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SummaryHeader extends StatelessWidget {
  final int count;

  const SummaryHeader({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0x26FFFFFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.gavel, color: AppColors.gold, size: 24),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                count == 1 ? 'Active case' : 'Active cases',
                style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
