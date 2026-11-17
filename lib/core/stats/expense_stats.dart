import 'package:expense_tracker/core/constants/categories.dart';
import 'package:expense_tracker/local/database/app_database.dart';

class CategorySpend {
  const CategorySpend({required this.category, required this.total});

  final ExpenseCategory category;
  final double total;
}

class DailySpend {
  const DailySpend({required this.day, required this.total});

  final DateTime day;
  final double total;
}

class ExpenseStats {
  const ExpenseStats({
    required this.totalSpent,
    required this.billCount,
    required this.categories,
    required this.days,
  });

  final double totalSpent;
  final int billCount;
  final List<CategorySpend> categories;
  final List<DailySpend> days;

  factory ExpenseStats.fromExpenses(List<ExpenseEntity> expenses) {
    final totals = {
      for (final category in ExpenseCategory.values) category.storedValue: 0.0,
    };
    final dayTotals = <DateTime, double>{};
    var total = 0.0;

    for (final expense in expenses) {
      final category = ExpenseCategory.match(expense.category);
      totals[category.storedValue] =
          (totals[category.storedValue] ?? 0) + expense.amount;
      total += expense.amount;
      final day = DateTime(
        expense.expenseDate.year,
        expense.expenseDate.month,
        expense.expenseDate.day,
      );
      dayTotals[day] = (dayTotals[day] ?? 0) + expense.amount;
    }

    final sortedDays = dayTotals.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return ExpenseStats(
      totalSpent: total,
      billCount: expenses.length,
      categories: [
        for (final category in ExpenseCategory.values)
          if ((totals[category.storedValue] ?? 0) > 0)
            CategorySpend(
              category: category,
              total: totals[category.storedValue]!,
            ),
      ],
      days: [
        for (final entry in sortedDays)
          DailySpend(day: entry.key, total: entry.value),
      ],
    );
  }
}
