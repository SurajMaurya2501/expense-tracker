import 'package:expense_tracker/local/repositories/expense_repository.dart';
import 'package:expense_tracker/screens/bills/bills_screen.dart';
import 'package:expense_tracker/screens/dashboard/dashboard_screen.dart';
import 'package:expense_tracker/services/notification_service.dart';
import 'package:flutter/material.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final _expenseRepo = ExpenseRepository();

  @override
  void initState() {
    super.initState();
    // Asks for notification permission (first run) and refreshes the
    // 14-day reminder schedule. Skips tonight's reminder if already logged.
    NotificationService.instance.sync(
      hasLoggedToday: () => _expenseRepo.hasExpenseOn(DateTime.now()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [DashboardScreen(), BillsScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Bills',
          ),
        ],
      ),
    );
  }
}
