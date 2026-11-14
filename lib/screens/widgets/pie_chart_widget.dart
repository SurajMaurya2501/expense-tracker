import 'dart:developer';

import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/local/repositories/expense_repository.dart';
import 'package:expense_tracker/screens/widgets/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatefulWidget {
  final List<CategorySummary> categories;
  const PieChartWidget({super.key, required this.categories});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartWidget> {
  int touchedIndex = -1;
  double totalValue = 0.0;

  @override
  void initState() {
    super.initState();
    getTotalExpense(categories: widget.categories);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(height: 18),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(
                    summary: widget.categories,
                    totalAmount: totalValue,
                  ),
                ),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: AppColors.contentColorBlue,
                text: 'Grocery',
                isSquare: true,
              ),
              SizedBox(height: 4),
              Indicator(
                color: AppColors.contentColorOrange,
                text: 'Digital Products',
                isSquare: true,
              ),
              SizedBox(height: 4),
              Indicator(
                color: AppColors.contentColorRed,
                text: 'Restaurant',
                isSquare: true,
              ),
              SizedBox(height: 4),
              Indicator(
                color: Colors.deepPurpleAccent,
                text: 'Others',
                isSquare: true,
              ),
              SizedBox(height: 18),
            ],
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections({
    required List<CategorySummary> summary,
    required double totalAmount,
  }) {
    return List.generate(summary.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final category = summary[i].category.toLowerCase();
      final color = category == 'grocery'
          ? AppColors.contentColorBlue
          : category == 'digital product'
          ? AppColors.contentColorOrange
          : category == 'restaurant'
          ? AppColors.contentColorRed
          : Colors.deepPurpleAccent;
      final value = ((summary[i].totalAmount / totalValue) * 100);
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        color: color,
        value: value,
        title: value.toStringAsFixed(2),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.mainTextColor1,
          shadows: shadows,
        ),
      );
    });
  }

  void getTotalExpense({required List<CategorySummary> categories}) {
    totalValue = categories.fold(
      0.0,
      (previousValue, element) => previousValue + element.totalAmount,
    );
    log('Total value - $totalValue');
  }
}
