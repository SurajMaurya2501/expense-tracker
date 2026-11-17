import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

BoxDecoration expenseCardDecoration({bool highlighted = false}) {
  return BoxDecoration(
    color: AppColors.itemsBackground,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
      color: highlighted
          ? AppColors.coinGold.withValues(alpha: 0.85)
          : Colors.white.withValues(alpha: 0.06),
    ),
  );
}
