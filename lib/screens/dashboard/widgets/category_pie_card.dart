import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/app_decorations.dart';
import 'package:expense_tracker/core/stats/expense_stats.dart';
import 'package:expense_tracker/core/utils/money_format.dart';
import 'package:expense_tracker/screens/widgets/indicator.dart';
import 'package:expense_tracker/screens/widgets/section_label.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieCard extends StatelessWidget {
  const CategoryPieCard({
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: expenseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(
            icon: Icons.pie_chart_outline,
            title: 'By category',
          ),
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              height: 220,
              width: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          if (event is! FlTapUpEvent) return;
                          final index =
                              response?.touchedSection?.touchedSectionIndex ??
                              -1;
                          if (index < 0 || index >= categories.length) return;
                          final stored = categories[index].category.storedValue;
                          onSelected(
                            stored == selectedStoredValue ? null : stored,
                          );
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 3,
                      centerSpaceRadius: 52,
                      sections: _sections(),
                    ),
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutCubic,
                  ),
                  IgnorePointer(
                    child: SizedBox(
                      width: 78,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              color: AppColors.mainTextColor3,
                              fontSize: 11,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              MoneyFormat.format(total),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final spend in categories)
                _LegendChip(
                  spend: spend,
                  selected: spend.category.storedValue == selectedStoredValue,
                  onTap: () {
                    final stored = spend.category.storedValue;
                    onSelected(stored == selectedStoredValue ? null : stored);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _sections() {
    return [
      for (final spend in categories)
        _section(spend, spend.category.storedValue == selectedStoredValue),
    ];
  }

  PieChartSectionData _section(CategorySpend spend, bool selected) {
    final percent = total <= 0 ? 0.0 : (spend.total / total) * 100;
    return PieChartSectionData(
      color: spend.category.color,
      value: spend.total,
      radius: selected ? 64 : 52,
      cornerRadius: 6,
      showTitle: percent >= 8,
      title: '${percent.round()}%',
      titleStyle: TextStyle(
        fontSize: selected ? 14 : 12,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        shadows: const [Shadow(color: Colors.black54, blurRadius: 2)],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({
    required this.spend,
    required this.selected,
    required this.onTap,
  });

  final CategorySpend spend;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: selected
              ? spend.category.color.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Indicator(
          color: spend.category.color,
          text: spend.category.label,
          isSquare: false,
          size: 10,
          fontSize: 13,
          textColor: selected ? Colors.white : AppColors.mainTextColor2,
        ),
      ),
    );
  }
}
