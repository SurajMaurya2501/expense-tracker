import 'package:expense_tracker/core/constants/app_theme.dart';
import 'package:expense_tracker/core/constants/categories.dart';
import 'package:expense_tracker/core/currency/app_currency.dart';
import 'package:expense_tracker/core/stats/expense_stats.dart';
import 'package:expense_tracker/core/utils/money_format.dart';
import 'package:expense_tracker/local/database/app_database.dart';
import 'package:expense_tracker/screens/bills/widgets/add_bill_actions.dart';
import 'package:expense_tracker/screens/bills/widgets/manual_entry_sheet.dart';
import 'package:expense_tracker/screens/dashboard/widgets/category_breakdown_list.dart';
import 'package:expense_tracker/screens/dashboard/widgets/category_pie_card.dart';
import 'package:expense_tracker/screens/dashboard/widgets/daily_spend_chart.dart';
import 'package:expense_tracker/screens/dashboard/widgets/dashboard_expense_list.dart';
import 'package:expense_tracker/screens/dashboard/widgets/spend_summary_card.dart';
import 'package:expense_tracker/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('groups spending by category and day', () {
    final stats = ExpenseStats.fromExpenses([
      _expense(id: 1, amount: 20, category: 'Grocery', day: 2),
      _expense(id: 2, amount: 10, category: 'Accesory', day: 2),
      _expense(id: 3, amount: 5, category: 'Accessory', day: 3),
    ]);

    expect(stats.totalSpent, 35);
    expect(stats.billCount, 3);
    expect(stats.categories.map((item) => item.category.label), [
      'Grocery',
      'Accessory',
    ]);
    expect(stats.categories[1].total, 15);
    expect(stats.days, hasLength(2));
    expect(stats.days.first.total, 30);
    expect(MoneyFormat.format(stats.totalSpent), r'$35.00');
  });

  test('uses the selected currency symbol', () {
    final previous = MoneyFormat.currency;
    MoneyFormat.use(AppCurrency.inr);
    expect(MoneyFormat.format(10), '₹10.00');
    expect(MoneyFormat.tryParse('₹12.50'), 12.5);
    MoneyFormat.use(previous);
  });

  testWidgets('onboarding skip opens the currency cards', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
    await tester.pump();

    expect(find.text('See what your spending is hiding'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      find.text(
        'Nothing is uploaded for storage. Only you can open this data.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Skip'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Which currency should your bills use?'), findsOneWidget);
    expect(find.text('₹'), findsOneWidget);
  });

  testWidgets('dashboard cards show totals and filter by category', (
    tester,
  ) async {
    await tester.pumpWidget(const _DashboardHarness());
    await tester.pumpAndSettle();

    expect(find.text(r'$30.00'), findsWidgets);
    expect(find.text('2 bills'), findsOneWidget);
    expect(find.text('Market'), findsOneWidget);
    expect(find.text('Tap a bar to see that day'), findsOneWidget);

    await tester.tap(find.text('Grocery').first);
    await tester.pumpAndSettle();

    expect(find.text('Show all'), findsOneWidget);
    expect(find.text('Cafe'), findsNothing);

    await tester.ensureVisible(find.text('Show all'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show all'));
    await tester.pumpAndSettle();

    expect(find.text('Show all'), findsNothing);
    expect(find.text('Cafe'), findsOneWidget);
  });

  testWidgets('manual entry saves a bill for the current month', (
    tester,
  ) async {
    await tester.pumpWidget(const _ManualHost());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Merchant'),
      'Corner Store',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Total'),
      '12.50',
    );
    await tester.tap(find.text('Add bill'));
    await tester.pumpAndSettle();

    expect(find.text('Grocery|Corner Store|12.5'), findsOneWidget);
  });

  testWidgets('bill actions expose the three entry points', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: AddBillActions(
            enabled: true,
            onManual: () {},
            onGallery: () {},
            onCamera: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Manual'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
    expect(find.text('Camera'), findsOneWidget);
  });
}

class _DashboardHarness extends StatefulWidget {
  const _DashboardHarness();

  @override
  State<_DashboardHarness> createState() => _DashboardHarnessState();
}

class _DashboardHarnessState extends State<_DashboardHarness> {
  String? _selected;

  static final _categories = [
    const CategorySpend(category: ExpenseCategory.grocery, total: 20),
    const CategorySpend(category: ExpenseCategory.restaurant, total: 10),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = _selected == null
        ? [_market, _cafe]
        : [_market, _cafe]
              .where(
                (expense) =>
                    ExpenseCategory.match(expense.category).storedValue ==
                    _selected,
              )
              .toList();

    return MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SpendSummaryCard(
                total: 30,
                billCount: 2,
                monthLabel: 'November 2026',
              ),
              CategoryPieCard(
                categories: _categories,
                total: 30,
                selectedStoredValue: _selected,
                onSelected: (value) => setState(() => _selected = value),
              ),
              CategoryBreakdownList(
                categories: _categories,
                total: 30,
                selectedStoredValue: _selected,
                onSelected: (value) => setState(() => _selected = value),
              ),
              DailySpendChart(
                days: [
                  DailySpend(day: DateTime(2026, 11, 2), total: 20),
                  DailySpend(day: DateTime(2026, 11, 3), total: 10),
                ],
              ),
              DashboardExpenseList(
                expenses: visible,
                selectedStoredValue: _selected,
                onClear: () => setState(() => _selected = null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManualHost extends StatelessWidget {
  const _ManualHost();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                final bill = await showManualEntrySheet(
                  context,
                  month: DateTime.now(),
                );
                if (!context.mounted) return;
                final label = bill == null
                    ? 'none'
                    : '${bill.category}|${bill.merchantName}|${bill.amount}';
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(label)));
              },
              child: const Text('Open'),
            );
          },
        ),
      ),
    );
  }
}

ExpenseEntity _expense({
  required int id,
  required double amount,
  required String category,
  required int day,
}) {
  return ExpenseEntity(
    id: id,
    amount: amount,
    category: category,
    merchantName: 'Shop',
    expenseDate: DateTime(2026, 11, day),
    monthYear: '11-2026',
    isManualEntry: false,
  );
}

final _market = ExpenseEntity(
  id: 1,
  amount: 20,
  category: 'Grocery',
  merchantName: 'Market',
  expenseDate: DateTime(2026, 11, 2),
  monthYear: '11-2026',
  isManualEntry: false,
);

final _cafe = ExpenseEntity(
  id: 2,
  amount: 10,
  category: 'Restaurant',
  merchantName: 'Cafe',
  expenseDate: DateTime(2026, 11, 3),
  monthYear: '11-2026',
  isManualEntry: true,
);
