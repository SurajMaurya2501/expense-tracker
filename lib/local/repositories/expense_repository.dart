import 'package:drift/drift.dart';
import 'package:expense_tracker/core/utils/month_key.dart';
import 'package:expense_tracker/local/database/app_database.dart';

class CategorySummary {
  final String category;
  final double totalAmount;

  CategorySummary({required this.category, required this.totalAmount});
}

class ExpenseRepository {
  final _db = AppDatabase();

  Future<int> insertExpense(ExpensesCompanion entity) async {
    return await _db.into(_db.expenses).insert(entity);
  }

  Future<int> deleteExpense(int id) {
    return (_db.delete(_db.expenses)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<ExpenseEntity>> watchExpenseForMonth(String yearMonth) {
    return (_db.select(_db.expenses)
          ..where((tbl) => tbl.monthYear.equals(yearMonth))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.expenseDate)]))
        .watch();
  }

  /// Months that have at least one expense, newest first.
  Stream<List<DateTime>> watchMonthsWithExpenses() {
    final monthYear = _db.expenses.monthYear;
    final query = _db.selectOnly(_db.expenses)
      ..addColumns([monthYear])
      ..groupBy([monthYear]);

    return query.watch().map((rows) {
      final months = <DateTime>[];
      for (final row in rows) {
        final key = row.read(monthYear);
        if (key == null) continue;
        final month = MonthKey.tryParse(key);
        if (month != null) months.add(month);
      }
      months.sort((a, b) {
        final byYear = b.year.compareTo(a.year);
        if (byYear != 0) return byYear;
        return b.month.compareTo(a.month);
      });
      return months;
    });
  }

  Stream<List<CategorySummary>> watchTotalExpenseSummary(String month) {
    final totalSum = _db.expenses.amount.sum();

    final query = _db.selectOnly(_db.expenses)
      ..addColumns([_db.expenses.category, totalSum])
      ..where(_db.expenses.monthYear.equals(month))
      ..groupBy([_db.expenses.category]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return CategorySummary(
          category: row.read(_db.expenses.category) ?? 'Others',
          totalAmount: row.read(totalSum) ?? 0.0,
        );
      }).toList();
    });
  }
}
