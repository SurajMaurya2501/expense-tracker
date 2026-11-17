import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/categories.dart';
import 'package:expense_tracker/core/utils/money_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BillFormFields extends StatelessWidget {
  const BillFormFields({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.merchantController,
    required this.amountController,
  });

  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final TextEditingController merchantController;
  final TextEditingController amountController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            color: AppColors.mainTextColor2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final category in ExpenseCategory.values)
              ChoiceChip(
                label: Text(category.label),
                avatar: Icon(category.icon, size: 18, color: category.color),
                selected: category.storedValue == selectedCategory,
                showCheckmark: false,
                labelStyle: TextStyle(
                  color: category.storedValue == selectedCategory
                      ? AppColors.coinGold
                      : AppColors.mainTextColor2,
                  fontWeight: category.storedValue == selectedCategory
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
                selectedColor: AppColors.coinGold.withValues(alpha: 0.18),
                backgroundColor: AppColors.menuBackground,
                side: BorderSide(
                  color: category.storedValue == selectedCategory
                      ? AppColors.coinGold
                      : Colors.white.withValues(alpha: 0.08),
                ),
                onSelected: (_) => onCategoryChanged(category.storedValue),
              ),
          ],
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: merchantController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Merchant',
            prefixIcon: Icon(Icons.storefront_outlined),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter the merchant name';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          decoration: InputDecoration(
            labelText: 'Total',
            prefixIcon: Center(
              widthFactor: 1,
              child: Text(
                MoneyFormat.currency.symbol,
                style: const TextStyle(
                  color: AppColors.coinGold,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          validator: (value) {
            final amount = MoneyFormat.tryParse(value ?? '');
            if (amount == null || amount <= 0 || !amount.isFinite) {
              return 'Enter an amount greater than 0';
            }
            return null;
          },
        ),
      ],
    );
  }
}
