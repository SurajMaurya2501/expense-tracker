import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/app_decorations.dart';
import 'package:expense_tracker/core/stats/expense_stats.dart';
import 'package:expense_tracker/core/utils/money_format.dart';
import 'package:expense_tracker/screens/widgets/section_label.dart';
import 'package:flutter/material.dart';

class CategoryBreakdownList extends StatelessWidget {
  const CategoryBreakdownList({
    super.key,
    required this.categories,
    required this.total,
    required this.selectedStoredValue,
    required this.onSelected,
  });

  final List<CategorySpend> categories;
  final double total;
  final String? selectedStoredValue;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(icon: Icons.donut_small_outlined, title: 'Share'),
        const SizedBox(height: 10),
        for (var i = 0; i < categories.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _CategoryShareRow(
            spend: categories[i],
            total: total,
            selected: categories[i].category.storedValue == selectedStoredValue,
            onTap: () {
              final stored = categories[i].category.storedValue;
              onSelected(stored == selectedStoredValue ? null : stored);
            },
          ),
        ],
      ],
    );
  }
}

class _CategoryShareRow extends StatelessWidget {
  const _CategoryShareRow({
    required this.spend,
    required this.total,
    required this.selected,
    required this.onTap,
  });

  final CategorySpend spend;
  final double total;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final share = total <= 0 ? 0.0 : (spend.total / total).clamp(0.0, 1.0);
    final category = spend.category;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: expenseCardDecoration(highlighted: selected),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(category.icon, color: category.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.label,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: share),
                          duration: const Duration(milliseconds: 650),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,
                              minHeight: 8,
                              backgroundColor: Colors.white12,
                              color: category.color,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      MoneyFormat.format(spend.total),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${(share * 100).round()}%',
                      style: const TextStyle(
                        color: AppColors.mainTextColor3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
