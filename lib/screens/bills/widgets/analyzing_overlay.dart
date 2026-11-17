import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnalyzingOverlay extends StatelessWidget {
  const AnalyzingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Center(
        child: Material(
          color: AppColors.itemsBackground,
          elevation: 8,
          borderRadius: BorderRadius.all(Radius.circular(28)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(28, 26, 28, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ReadingMark(),
                SizedBox(height: 16),
                Text(
                  'Reading your bill',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 6),
                SizedBox(
                  width: 220,
                  child: Text(
                    'Checking the merchant, category, and total',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.mainTextColor2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadingMark extends StatelessWidget {
  const _ReadingMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.monetization_on, size: 84, color: Color(0x33FFC857))
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .rotate(begin: -0.06, end: 0.06, duration: 1100.ms),
          const Icon(Icons.receipt_long, size: 40, color: AppColors.coinGold)
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.92, 0.92),
                end: const Offset(1.06, 1.06),
                duration: 900.ms,
                curve: Curves.easeInOut,
              ),
        ],
      ),
    );
  }
}
