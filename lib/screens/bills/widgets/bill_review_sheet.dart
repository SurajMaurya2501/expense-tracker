import 'dart:io';

import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/categories.dart';
import 'package:expense_tracker/core/utils/money_format.dart';
import 'package:expense_tracker/models/confirmed_bill.dart';
import 'package:expense_tracker/screens/bills/widgets/bill_form_fields.dart';
import 'package:expense_tracker/services/bill_capture_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

Future<ConfirmedBill?> showBillReviewSheet(
  BuildContext context, {
  required BillDraft draft,
}) {
  return showModalBottomSheet<ConfirmedBill>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => BillReviewSheet(draft: draft),
  );
}

class BillReviewSheet extends StatefulWidget {
  const BillReviewSheet({super.key, required this.draft});

  final BillDraft draft;

  @override
  State<BillReviewSheet> createState() => _BillReviewSheetState();
}

class _BillReviewSheetState extends State<BillReviewSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _merchant;
  late final TextEditingController _amount;
  late String _category;

  @override
  void initState() {
    super.initState();
    final analysis = widget.draft.analysis;
    final merchant = analysis.merchantName.trim();
    _merchant = TextEditingController(
      text: merchant.isEmpty || merchant == '-' ? '' : merchant,
    );
    _amount = TextEditingController(
      text: analysis.totalAmount > 0
          ? analysis.totalAmount.toStringAsFixed(2)
          : '',
    );
    _category = ExpenseCategory.match(analysis.category).storedValue;
  }

  @override
  void dispose() {
    _merchant.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = MoneyFormat.tryParse(_amount.text);
    if (amount == null) return;
    final now = DateTime.now();
    Navigator.pop(
      context,
      ConfirmedBill(
        category: _category,
        merchantName: _merchant.text.trim(),
        amount: amount,
        expenseDate: DateTime(now.year, now.month, now.day),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBill = widget.draft.analysis.isBill;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child:
              Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Check this bill',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Confirm the category, merchant, and total before saving.',
                        style: TextStyle(color: AppColors.mainTextColor2),
                      ),
                      const SizedBox(height: 14),
                      _BillPhoto(image: widget.draft.image),
                      if (!isBill) ...[
                        const SizedBox(height: 12),
                        const _NotABillWarning(),
                      ],
                      const SizedBox(height: 14),
                      BillFormFields(
                        selectedCategory: _category,
                        onCategoryChanged: (value) =>
                            setState(() => _category = value),
                        merchantController: _merchant,
                        amountController: _amount,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Discard'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: _save,
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                  .animate()
                  .fadeIn(duration: 250.ms)
                  .slideY(begin: 0.06, end: 0, duration: 250.ms),
        ),
      ),
    );
  }
}

class _BillPhoto extends StatelessWidget {
  const _BillPhoto({required this.image});

  final File image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        image,
        height: 168,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: Icon(Icons.receipt_long, color: AppColors.coinGold),
            ),
          );
        },
      ),
    );
  }
}

class _NotABillWarning extends StatelessWidget {
  const _NotABillWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.contentColorOrange.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.contentColorOrange.withValues(alpha: 0.45),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.contentColorOrange,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'This photo does not look like a bill. Correct the details or discard it.',
            ),
          ),
        ],
      ),
    );
  }
}
