import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/utils/month_key.dart';
import 'package:expense_tracker/local/database/app_database.dart';
import 'package:expense_tracker/local/repositories/expense_repository.dart';
import 'package:expense_tracker/models/confirmed_bill.dart';
import 'package:expense_tracker/screens/bills/widgets/add_bill_actions.dart';
import 'package:expense_tracker/screens/bills/widgets/analyzing_overlay.dart';
import 'package:expense_tracker/screens/bills/widgets/bill_review_sheet.dart';
import 'package:expense_tracker/screens/bills/widgets/manual_entry_sheet.dart';
import 'package:expense_tracker/screens/widgets/empty_spend_view.dart';
import 'package:expense_tracker/screens/widgets/expense_tile.dart';
import 'package:expense_tracker/screens/widgets/screen_header.dart';
import 'package:expense_tracker/screens/widgets/section_label.dart';
import 'package:expense_tracker/services/bill_capture_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final _repo = ExpenseRepository();
  final _capture = BillCaptureService();
  final _hiddenIds = <int>{};
  late final DateTime _month;
  late final Stream<List<ExpenseEntity>> _expenses;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month, now.day);
    _expenses = _repo.watchExpenseForMonth(MonthKey.of(_month));
  }

  Future<void> _addManual() async {
    if (_busy) return;
    final confirmed = await showManualEntrySheet(context, month: _month);
    if (confirmed == null || !mounted) return;
    await _save(confirmed, manual: true);
  }

  Future<void> _captureFrom(ImageSource source) async {
    if (_busy) return;
    File? image;
    try {
      image = await _capture.pick(source);
    } catch (_) {
      if (!mounted) return;
      _showMessage(
        source == ImageSource.camera
            ? 'Could not open the camera.'
            : 'Could not open the gallery.',
      );
      return;
    }
    if (image == null || !mounted) return;

    setState(() => _busy = true);
    final draft = await _readBill(image);
    if (!mounted) return;
    setState(() => _busy = false);
    if (draft == null) return;

    final confirmed = await showBillReviewSheet(context, draft: draft);
    if (confirmed == null || !mounted) return;
    await _save(confirmed, manual: false);
  }

  Future<BillDraft?> _readBill(File image) async {
    if (!mounted) return null;
    var dialogOpen = true;
    final navigator = Navigator.of(context, rootNavigator: true);
    unawaited(
      showGeneralDialog<void>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        barrierLabel: 'Reading bill',
        barrierColor: const Color(0xE6090912),
        transitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const AnalyzingOverlay();
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ).whenComplete(() => dialogOpen = false),
    );
    await WidgetsBinding.instance.endOfFrame;

    try {
      return await _capture.analyze(image);
    } catch (_) {
      if (mounted) {
        _showMessage('Could not read that bill. Try another photo.');
      }
      return null;
    } finally {
      if (dialogOpen && navigator.mounted) {
        navigator.pop();
      }
    }
  }

  Future<void> _save(ConfirmedBill bill, {required bool manual}) async {
    try {
      await _repo.insertExpense(
        ExpensesCompanion.insert(
          amount: bill.amount,
          category: bill.category,
          merchantName: bill.merchantName,
          expenseDate: bill.expenseDate,
          monthYear: MonthKey.of(bill.expenseDate),
          isManualEntry: Value(manual),
        ),
      );
      if (!mounted) return;
      _showMessage('Bill saved');
    } catch (_) {
      if (!mounted) return;
      _showMessage('Could not save that bill.');
    }
  }

  Future<void> _delete(ExpenseEntity expense) async {
    setState(() => _hiddenIds.add(expense.id));
    try {
      await _repo.deleteExpense(expense.id);
      if (!mounted) return;
      _showMessage('Bill removed');
    } catch (_) {
      if (!mounted) return;
      setState(() => _hiddenIds.remove(expense.id));
      _showMessage('Could not remove that bill.');
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: StreamBuilder<List<ExpenseEntity>>(
        stream: _expenses,
        builder: (context, snapshot) {
          final expenses = (snapshot.data ?? const <ExpenseEntity>[])
              .where((expense) => !_hiddenIds.contains(expense.id))
              .toList();
          final failed = snapshot.hasError;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              ScreenHeader(
                icon: Icons.receipt_long_outlined,
                title: 'Bills',
                subtitle: MonthKey.title(_month),
              ),
              const SizedBox(height: 16),
              AddBillActions(
                enabled: !_busy,
                onManual: _addManual,
                onGallery: () => _captureFrom(ImageSource.gallery),
                onCamera: () => _captureFrom(ImageSource.camera),
              ),
              const SizedBox(height: 22),
              const SectionLabel(
                icon: Icons.payments_outlined,
                title: 'Saved bills',
              ),
              const SizedBox(height: 10),
              if (failed)
                const Text('Could not load bills')
              else if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (expenses.isEmpty)
                const EmptySpendView(
                  title: 'No bills yet',
                  message:
                      'Add one manually, from your gallery, or with the camera.',
                )
              else
                for (var index = 0; index < expenses.length; index++) ...[
                  Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Dismissible(
                          key: ValueKey(expenses[index].id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => _delete(expenses[index]),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.contentColorRed,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                          child: ExpenseTile(expense: expenses[index]),
                        ),
                      )
                      .animate(key: ValueKey('bill-${expenses[index].id}'))
                      .fadeIn(
                        delay: (index.clamp(0, 8) * 40).ms,
                        duration: 280.ms,
                      ),
                ],
            ],
          );
        },
      ),
    );
  }
}
