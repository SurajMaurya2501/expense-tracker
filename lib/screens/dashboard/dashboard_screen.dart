import 'package:expense_tracker/core/constants/categories.dart';
import 'package:expense_tracker/core/stats/expense_stats.dart';
import 'package:expense_tracker/core/utils/month_key.dart';
import 'package:expense_tracker/local/database/app_database.dart';
import 'package:expense_tracker/local/repositories/expense_repository.dart';
import 'package:expense_tracker/screens/dashboard/widgets/category_breakdown_list.dart';
import 'package:expense_tracker/screens/dashboard/widgets/category_pie_card.dart';
import 'package:expense_tracker/screens/dashboard/widgets/daily_spend_chart.dart';
import 'package:expense_tracker/screens/dashboard/widgets/dashboard_expense_list.dart';
import 'package:expense_tracker/screens/dashboard/widgets/month_selector.dart';
import 'package:expense_tracker/screens/dashboard/widgets/spend_summary_card.dart';
import 'package:expense_tracker/screens/widgets/empty_spend_view.dart';
import 'package:expense_tracker/screens/widgets/screen_header.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _repo = ExpenseRepository();
  late DateTime _month;
  late Stream<List<ExpenseEntity>> _expenses;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _expenses = _repo.watchExpenseForMonth(MonthKey.of(_month));
  }

  void _setMonth(DateTime month) {
    final next = DateTime(month.year, month.month);
    if (next.year == _month.year && next.month == _month.month) return;
    setState(() {
      _month = next;
      _selectedCategory = null;
      _expenses = _repo.watchExpenseForMonth(MonthKey.of(next));
    });
  }

  void _selectCategory(String? storedValue) {
    setState(() => _selectedCategory = storedValue);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: StreamBuilder<List<ExpenseEntity>>(
        stream: _expenses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Could not load expenses'));
          }

          final expenses = snapshot.data ?? const <ExpenseEntity>[];
          final stats = ExpenseStats.fromExpenses(expenses);
          final selected =
              stats.categories.any(
                (item) => item.category.storedValue == _selectedCategory,
              )
              ? _selectedCategory
              : null;
          final visible = selected == null
              ? expenses
              : expenses
                    .where(
                      (expense) =>
                          ExpenseCategory.match(expense.category).storedValue ==
                          selected,
                    )
                    .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              const ScreenHeader(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Dashboard',
                subtitle: 'Where your money went',
              ),
              const SizedBox(height: 16),
              MonthSelector(
                months: MonthKey.recent(),
                selected: _month,
                onSelected: _setMonth,
              ),
              const SizedBox(height: 16),
              SpendSummaryCard(
                key: ValueKey(MonthKey.of(_month)),
                total: stats.totalSpent,
                billCount: stats.billCount,
                monthLabel: MonthKey.title(_month),
              ),
              const SizedBox(height: 16),
              if (expenses.isEmpty)
                const EmptySpendView(
                  title: 'No expenses this month',
                  message:
                      'Add a bill and this view will fill in with categories and daily totals.',
                )
              else ...[
                CategoryPieCard(
                  categories: stats.categories,
                  total: stats.totalSpent,
                  selectedStoredValue: selected,
                  onSelected: _selectCategory,
                ),
                const SizedBox(height: 16),
                CategoryBreakdownList(
                  categories: stats.categories,
                  total: stats.totalSpent,
                  selectedStoredValue: selected,
                  onSelected: _selectCategory,
                ),
                const SizedBox(height: 16),
                DailySpendChart(
                  key: ValueKey(MonthKey.of(_month)),
                  days: stats.days,
                ),
                const SizedBox(height: 16),
                DashboardExpenseList(
                  expenses: visible,
                  selectedStoredValue: selected,
                  onClear: () => _selectCategory(null),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
