import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/utils/money_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SpendSummaryCard extends StatelessWidget {
  const SpendSummaryCard({
    super.key,
    required this.total,
    required this.billCount,
    required this.monthLabel,
  });

  final double total;
  final int billCount;
  final String monthLabel;

  @override
  Widget build(BuildContext context) {
    final billsLabel = billCount == 1 ? '1 bill' : '$billCount bills';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF243056), Color(0xFF1B2339)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.coinGold.withValues(alpha: 0.28)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            const Positioned(
              right: -12,
              bottom: -18,
              child: Icon(
                Icons.monetization_on,
                size: 120,
                color: Color(0x14FFC857),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monthLabel,
                    style: const TextStyle(color: AppColors.mainTextColor2),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: AppColors.coinGold,
                        size: 28,
                      ).animate().scale(
                        begin: const Offset(0.6, 0.6),
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: _CountUpAmount(value: total)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    billsLabel,
                    style: const TextStyle(color: AppColors.mainTextColor3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountUpAmount extends StatelessWidget {
  const _CountUpAmount({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, amount, child) {
        return Text(
          MoneyFormat.format(amount),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
