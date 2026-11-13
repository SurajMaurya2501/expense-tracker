// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExpensesTable extends Expenses
    with TableInfo<$ExpensesTable, ExpenseEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantNameMeta = const VerificationMeta(
    'merchantName',
  );
  @override
  late final GeneratedColumn<String> merchantName = GeneratedColumn<String>(
    'merchant_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expenseDateMeta = const VerificationMeta(
    'expenseDate',
  );
  @override
  late final GeneratedColumn<DateTime> expenseDate = GeneratedColumn<DateTime>(
    'expense_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthYearMeta = const VerificationMeta(
    'monthYear',
  );
  @override
  late final GeneratedColumn<String> monthYear = GeneratedColumn<String>(
    'month_year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isManualEntryMeta = const VerificationMeta(
    'isManualEntry',
  );
  @override
  late final GeneratedColumn<bool> isManualEntry = GeneratedColumn<bool>(
    'is_manual_entry',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_manual_entry" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    category,
    merchantName,
    expenseDate,
    monthYear,
    isManualEntry,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('merchant_name')) {
      context.handle(
        _merchantNameMeta,
        merchantName.isAcceptableOrUnknown(
          data['merchant_name']!,
          _merchantNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_merchantNameMeta);
    }
    if (data.containsKey('expense_date')) {
      context.handle(
        _expenseDateMeta,
        expenseDate.isAcceptableOrUnknown(
          data['expense_date']!,
          _expenseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expenseDateMeta);
    }
    if (data.containsKey('month_year')) {
      context.handle(
        _monthYearMeta,
        monthYear.isAcceptableOrUnknown(data['month_year']!, _monthYearMeta),
      );
    } else if (isInserting) {
      context.missing(_monthYearMeta);
    }
    if (data.containsKey('is_manual_entry')) {
      context.handle(
        _isManualEntryMeta,
        isManualEntry.isAcceptableOrUnknown(
          data['is_manual_entry']!,
          _isManualEntryMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      merchantName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_name'],
      )!,
      expenseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expense_date'],
      )!,
      monthYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month_year'],
      )!,
      isManualEntry: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_manual_entry'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class ExpenseEntity extends DataClass implements Insertable<ExpenseEntity> {
  final int id;
  final double amount;
  final String category;
  final String merchantName;
  final DateTime expenseDate;
  final String monthYear;
  final bool isManualEntry;
  const ExpenseEntity({
    required this.id,
    required this.amount,
    required this.category,
    required this.merchantName,
    required this.expenseDate,
    required this.monthYear,
    required this.isManualEntry,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    map['merchant_name'] = Variable<String>(merchantName);
    map['expense_date'] = Variable<DateTime>(expenseDate);
    map['month_year'] = Variable<String>(monthYear);
    map['is_manual_entry'] = Variable<bool>(isManualEntry);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      amount: Value(amount),
      category: Value(category),
      merchantName: Value(merchantName),
      expenseDate: Value(expenseDate),
      monthYear: Value(monthYear),
      isManualEntry: Value(isManualEntry),
    );
  }

  factory ExpenseEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseEntity(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      merchantName: serializer.fromJson<String>(json['merchantName']),
      expenseDate: serializer.fromJson<DateTime>(json['expenseDate']),
      monthYear: serializer.fromJson<String>(json['monthYear']),
      isManualEntry: serializer.fromJson<bool>(json['isManualEntry']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'merchantName': serializer.toJson<String>(merchantName),
      'expenseDate': serializer.toJson<DateTime>(expenseDate),
      'monthYear': serializer.toJson<String>(monthYear),
      'isManualEntry': serializer.toJson<bool>(isManualEntry),
    };
  }

  ExpenseEntity copyWith({
    int? id,
    double? amount,
    String? category,
    String? merchantName,
    DateTime? expenseDate,
    String? monthYear,
    bool? isManualEntry,
  }) => ExpenseEntity(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    merchantName: merchantName ?? this.merchantName,
    expenseDate: expenseDate ?? this.expenseDate,
    monthYear: monthYear ?? this.monthYear,
    isManualEntry: isManualEntry ?? this.isManualEntry,
  );
  ExpenseEntity copyWithCompanion(ExpensesCompanion data) {
    return ExpenseEntity(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      merchantName: data.merchantName.present
          ? data.merchantName.value
          : this.merchantName,
      expenseDate: data.expenseDate.present
          ? data.expenseDate.value
          : this.expenseDate,
      monthYear: data.monthYear.present ? data.monthYear.value : this.monthYear,
      isManualEntry: data.isManualEntry.present
          ? data.isManualEntry.value
          : this.isManualEntry,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseEntity(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('merchantName: $merchantName, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('monthYear: $monthYear, ')
          ..write('isManualEntry: $isManualEntry')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    category,
    merchantName,
    expenseDate,
    monthYear,
    isManualEntry,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseEntity &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.merchantName == this.merchantName &&
          other.expenseDate == this.expenseDate &&
          other.monthYear == this.monthYear &&
          other.isManualEntry == this.isManualEntry);
}

class ExpensesCompanion extends UpdateCompanion<ExpenseEntity> {
  final Value<int> id;
  final Value<double> amount;
  final Value<String> category;
  final Value<String> merchantName;
  final Value<DateTime> expenseDate;
  final Value<String> monthYear;
  final Value<bool> isManualEntry;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.expenseDate = const Value.absent(),
    this.monthYear = const Value.absent(),
    this.isManualEntry = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required String category,
    required String merchantName,
    required DateTime expenseDate,
    required String monthYear,
    this.isManualEntry = const Value.absent(),
  }) : amount = Value(amount),
       category = Value(category),
       merchantName = Value(merchantName),
       expenseDate = Value(expenseDate),
       monthYear = Value(monthYear);
  static Insertable<ExpenseEntity> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<String>? merchantName,
    Expression<DateTime>? expenseDate,
    Expression<String>? monthYear,
    Expression<bool>? isManualEntry,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (merchantName != null) 'merchant_name': merchantName,
      if (expenseDate != null) 'expense_date': expenseDate,
      if (monthYear != null) 'month_year': monthYear,
      if (isManualEntry != null) 'is_manual_entry': isManualEntry,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<double>? amount,
    Value<String>? category,
    Value<String>? merchantName,
    Value<DateTime>? expenseDate,
    Value<String>? monthYear,
    Value<bool>? isManualEntry,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      merchantName: merchantName ?? this.merchantName,
      expenseDate: expenseDate ?? this.expenseDate,
      monthYear: monthYear ?? this.monthYear,
      isManualEntry: isManualEntry ?? this.isManualEntry,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (merchantName.present) {
      map['merchant_name'] = Variable<String>(merchantName.value);
    }
    if (expenseDate.present) {
      map['expense_date'] = Variable<DateTime>(expenseDate.value);
    }
    if (monthYear.present) {
      map['month_year'] = Variable<String>(monthYear.value);
    }
    if (isManualEntry.present) {
      map['is_manual_entry'] = Variable<bool>(isManualEntry.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('merchantName: $merchantName, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('monthYear: $monthYear, ')
          ..write('isManualEntry: $isManualEntry')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [expenses];
}

typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required double amount,
      required String category,
      required String merchantName,
      required DateTime expenseDate,
      required String monthYear,
      Value<bool> isManualEntry,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<double> amount,
      Value<String> category,
      Value<String> merchantName,
      Value<DateTime> expenseDate,
      Value<String> monthYear,
      Value<bool> isManualEntry,
    });

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expenseDate => $composableBuilder(
    column: $table.expenseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get monthYear => $composableBuilder(
    column: $table.monthYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isManualEntry => $composableBuilder(
    column: $table.isManualEntry,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expenseDate => $composableBuilder(
    column: $table.expenseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get monthYear => $composableBuilder(
    column: $table.monthYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isManualEntry => $composableBuilder(
    column: $table.isManualEntry,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expenseDate => $composableBuilder(
    column: $table.expenseDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get monthYear =>
      $composableBuilder(column: $table.monthYear, builder: (column) => column);

  GeneratedColumn<bool> get isManualEntry => $composableBuilder(
    column: $table.isManualEntry,
    builder: (column) => column,
  );
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          ExpenseEntity,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (
            ExpenseEntity,
            BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseEntity>,
          ),
          ExpenseEntity,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> merchantName = const Value.absent(),
                Value<DateTime> expenseDate = const Value.absent(),
                Value<String> monthYear = const Value.absent(),
                Value<bool> isManualEntry = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                amount: amount,
                category: category,
                merchantName: merchantName,
                expenseDate: expenseDate,
                monthYear: monthYear,
                isManualEntry: isManualEntry,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double amount,
                required String category,
                required String merchantName,
                required DateTime expenseDate,
                required String monthYear,
                Value<bool> isManualEntry = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                amount: amount,
                category: category,
                merchantName: merchantName,
                expenseDate: expenseDate,
                monthYear: monthYear,
                isManualEntry: isManualEntry,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpensesTable, ExpenseEntity>(table),
                  BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseEntity>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      ExpenseEntity,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (
        ExpenseEntity,
        BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseEntity>,
      ),
      ExpenseEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
}
