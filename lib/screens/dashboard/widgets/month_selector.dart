import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/utils/month_key.dart';
import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.months,
    required this.selected,
    required this.onSelected,
  });

  final List<DateTime> months;
  final DateTime selected;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final month = months[index];
          final isSelected =
              month.year == selected.year && month.month == selected.month;
          return ChoiceChip(
            label: Text(MonthKey.chipLabel(month)),
            selected: isSelected,
            showCheckmark: false,
            visualDensity: VisualDensity.compact,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.coinGold : AppColors.mainTextColor2,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            selectedColor: AppColors.coinGold.withValues(alpha: 0.18),
            backgroundColor: AppColors.pageBackground,
            side: BorderSide(
              color: isSelected
                  ? AppColors.coinGold
                  : Colors.white.withValues(alpha: 0.08),
            ),
            onSelected: (_) => onSelected(DateTime(month.year, month.month)),
          );
        },
      ),
    );
  }
}
