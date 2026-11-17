import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/app_decorations.dart';
import 'package:expense_tracker/core/stats/expense_stats.dart';
import 'package:expense_tracker/core/utils/money_format.dart';
import 'package:expense_tracker/core/utils/month_key.dart';
import 'package:expense_tracker/screens/widgets/section_label.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailySpendChart extends StatefulWidget {
  const DailySpendChart({super.key, required this.days});

  final List<DailySpend> days;

  @override
  State<DailySpendChart> createState() => _DailySpendChartState();
}

class _DailySpendChartState extends State<DailySpendChart> {
  int _touched = -1;

  @override
  void didUpdateWidget(DailySpendChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.days.length != widget.days.length) {
      _touched = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.days.isEmpty) return const SizedBox.shrink();

    final days = widget.days;
    final maxValue = days
        .map((day) => day.total)
        .reduce((a, b) => a > b ? a : b);
    final maxY = maxValue <= 0 ? 1.0 : maxValue * 1.25;
    final rodWidth = days.length > 20
        ? 7.0
        : days.length > 12
        ? 10.0
        : 16.0;
    final labelStep = days.length <= 6 ? 1 : (days.length / 6).ceil();
    final hasSelection = _touched >= 0 && _touched < days.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: expenseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(icon: Icons.bar_chart, title: 'By day'),
          const SizedBox(height: 4),
          Text(
            hasSelection
                ? '${MonthKey.fullDay(days[_touched].day)} · ${MoneyFormat.format(days[_touched].total)}'
                : 'Tap a bar to see that day',
            style: TextStyle(
              color: hasSelection
                  ? AppColors.coinGold
                  : AppColors.mainTextColor3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: maxY,
                alignment: BarChartAlignment.spaceEvenly,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
                      const FlLine(color: Colors.white10, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBorderRadius: BorderRadius.circular(10),
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipColor: (group) => AppColors.pageBackground,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final index = group.x;
                      if (index < 0 || index >= days.length) return null;
                      return BarTooltipItem(
                        '${MonthKey.dayLabel(days[index].day)}\n${MoneyFormat.format(rod.toY)}',
                        const TextStyle(
                          color: AppColors.coinGold,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                  touchCallback: (event, response) {
                    if (event is! FlTapUpEvent) return;
                    final index = response?.spot?.touchedBarGroupIndex;
                    setState(() {
                      if (index == null || index < 0 || index >= days.length) {
                        _touched = -1;
                      } else {
                        _touched = _touched == index ? -1 : index;
                      }
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= days.length) {
                          return const SizedBox.shrink();
                        }
                        final showLabel =
                            index % labelStep == 0 || index == days.length - 1;
                        if (!showLabel) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '${days[index].day.day}',
                            style: const TextStyle(
                              color: AppColors.mainTextColor3,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var index = 0; index < days.length; index++)
                    BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: days[index].total,
                          width: _touched == index ? rodWidth + 4 : rodWidth,
                          color: _touched == index
                              ? const Color(0xFFFFE7A3)
                              : AppColors.coinGold,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }
}
