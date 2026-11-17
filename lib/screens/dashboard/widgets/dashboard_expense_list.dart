import 'package:expense_tracker/core/constants/categories.dart';
import 'package:expense_tracker/local/database/app_database.dart';
import 'package:expense_tracker/screens/widgets/expense_tile.dart';
import 'package:expense_tracker/screens/widgets/section_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardExpenseList extends StatelessWidget {
  const DashboardExpenseList({
    super.key,
    required this.expenses,
    required this.selectedStoredValue,
    required this.onClear,
  });

  final List<ExpenseEntity> expenses;
  final String? selectedStoredValue;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final title = selectedStoredValue == null
        ? 'Expenses'
        : ExpenseCategory.match(selectedStoredValue).label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SectionLabel(
                icon: Icons.receipt_long_outlined,
                title: title,
              ),
            ),
            if (selectedStoredValue != null)
              TextButton(onPressed: onClear, child: const Text('Show all')),
          ],
        ),
        const SizedBox(height: 10),
        if (expenses.isEmpty)
          const Text('Nothing in this category.')
        else
          for (var index = 0; index < expenses.length; index++) ...[
            ExpenseTile(expense: expenses[index])
                .animate(key: ValueKey(expenses[index].id))
                .fadeIn(delay: (index.clamp(0, 8) * 40).ms, duration: 280.ms),
            if (index != expenses.length - 1) const SizedBox(height: 10),
          ],
      ],
    );
  }
}
