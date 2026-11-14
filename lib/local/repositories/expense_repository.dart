import 'package:drift/drift.dart';
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

  Stream<List<ExpenseEntity>> watchExpenseForMonth(String yearMonth) {
    return (_db.select(_db.expenses)
          ..where((tbl) => tbl.monthYear.equals(yearMonth))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.expenseDate)]))
        .watch();
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
