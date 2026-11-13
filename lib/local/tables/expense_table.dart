import 'package:drift/drift.dart';

@DataClassName('ExpenseEntity')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  TextColumn get merchantName => text()();
  DateTimeColumn get expenseDate => dateTime()();
  TextColumn get monthYear => text()();
  BoolColumn get isManualEntry =>
      boolean().withDefault(const Constant(false))();
}
