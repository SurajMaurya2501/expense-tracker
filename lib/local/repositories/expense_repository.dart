import 'package:drift/drift.dart';
import 'package:expense_tracker/local/database/app_database.dart';

class ExpenseRepository {
  final _db = AppDatabase();

  Future<int> insertExpense(ExpensesCompanion entity) async {
    return await _db.into(_db.expenses).insert(entity);
  }

  Stream<List<ExpenseEntity>> watchExpenseForMonth(String yearMonth) {
    return (_db.select(_db.expenses)
      ..where((tbl) => tbl.monthYear.equals(yearMonth))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.expenseDate)])).watch();
  }
}
