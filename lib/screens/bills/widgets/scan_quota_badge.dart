import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/services/scan_quota_service.dart';
import 'package:flutter/material.dart';

/// "12 of 20 free scans left", or a hint to add bills manually once used up.
class ScanQuotaBadge extends StatelessWidget {
  const ScanQuotaBadge({super.key, required this.remaining});

  /// Scans left, or null while it is still being read.
  final int? remaining;

  @override
  Widget build(BuildContext context) {
    final left = remaining;
    if (left == null) return const SizedBox.shrink();

    final exhausted = left == 0;
    final color = exhausted
        ? AppColors.contentColorOrange
        : left <= 5
        ? AppColors.contentColorYellow
        : AppColors.mainTextColor2;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_outlined, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              exhausted
                  ? 'Free scans used up. You can still add bills manually.'
                  : '$left of ${ScanQuotaService.limit} free scans left',
              style: TextStyle(color: color, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
