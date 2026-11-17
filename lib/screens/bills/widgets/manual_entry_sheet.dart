import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/categories.dart';
import 'package:expense_tracker/core/utils/money_format.dart';
import 'package:expense_tracker/core/utils/month_key.dart';
import 'package:expense_tracker/models/confirmed_bill.dart';
import 'package:expense_tracker/screens/bills/widgets/bill_form_fields.dart';
import 'package:flutter/material.dart';

Future<ConfirmedBill?> showManualEntrySheet(
  BuildContext context, {
  required DateTime month,
}) {
  return showModalBottomSheet<ConfirmedBill>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => ManualEntrySheet(month: month),
  );
}

class ManualEntrySheet extends StatefulWidget {
  const ManualEntrySheet({super.key, required this.month});

  final DateTime month;

  @override
  State<ManualEntrySheet> createState() => _ManualEntrySheetState();
}

class _ManualEntrySheetState extends State<ManualEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _merchant = TextEditingController();
  final _amount = TextEditingController();
  late DateTime _date;
  late final DateTime _firstDate;
  late final DateTime _lastDate;
  String _category = ExpenseCategory.grocery.storedValue;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final start = DateTime(widget.month.year, widget.month.month);
    final endOfMonth = DateTime(widget.month.year, widget.month.month + 1, 0);
    var last = DateTime(today.year, today.month, today.day);
    if (last.isBefore(start)) last = start;
    if (last.isAfter(endOfMonth)) last = endOfMonth;
    _firstDate = start;
    _lastDate = last;
    _date = last;
  }

  @override
  void dispose() {
    _merchant.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: _firstDate,
      lastDate: _lastDate,
      helpText: 'Bill date',
    );
    if (picked == null) return;
    setState(() {
      _date = DateTime(picked.year, picked.month, picked.day);
    });
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = MoneyFormat.tryParse(_amount.text);
    if (amount == null) return;
    Navigator.pop(
      context,
      ConfirmedBill(
        category: _category,
        merchantName: _merchant.text.trim(),
        amount: amount,
        expenseDate: _date,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add a bill',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Saved to ${MonthKey.title(widget.month)}',
                style: const TextStyle(color: AppColors.mainTextColor2),
              ),
              const SizedBox(height: 16),
              BillFormFields(
                selectedCategory: _category,
                onCategoryChanged: (value) => setState(() => _category = value),
                merchantController: _merchant,
                amountController: _amount,
              ),
              const SizedBox(height: 12),
              Material(
                color: AppColors.menuBackground,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _pickDate,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: AppColors.coinGold,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date',
                                style: TextStyle(
                                  color: AppColors.mainTextColor2,
                                  fontSize: 12,
                                ),
                              ),
                              Text(MonthKey.fullDay(_date)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _save,
                      child: const Text('Add bill'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
