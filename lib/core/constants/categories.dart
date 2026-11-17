import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ExpenseCategory {
  const ExpenseCategory({
    required this.storedValue,
    required this.label,
    required this.color,
    required this.icon,
  });

  final String storedValue;
  final String label;
  final Color color;
  final IconData icon;

  static const grocery = ExpenseCategory(
    storedValue: 'Grocery',
    label: 'Grocery',
    color: AppColors.contentColorBlue,
    icon: Icons.local_grocery_store_outlined,
  );

  static const accessory = ExpenseCategory(
    storedValue: 'Accesory',
    label: 'Accessory',
    color: AppColors.contentColorPurple,
    icon: Icons.watch_outlined,
  );

  static const digital = ExpenseCategory(
    storedValue: 'Digital Product',
    label: 'Digital Product',
    color: AppColors.contentColorOrange,
    icon: Icons.devices_outlined,
  );

  static const restaurant = ExpenseCategory(
    storedValue: 'Restaurant',
    label: 'Restaurant',
    color: AppColors.contentColorRed,
    icon: Icons.restaurant_outlined,
  );

  static const others = ExpenseCategory(
    storedValue: 'Others',
    label: 'Others',
    color: AppColors.contentColorPink,
    icon: Icons.payments_outlined,
  );

  static const values = <ExpenseCategory>[
    grocery,
    accessory,
    digital,
    restaurant,
    others,
  ];

  static ExpenseCategory match(String? raw) {
    switch ((raw ?? '').trim().toLowerCase()) {
      case 'grocery':
        return grocery;
      case 'accesory':
      case 'accessory':
      case 'accessories':
        return accessory;
      case 'digital product':
      case 'digital products':
        return digital;
      case 'restaurant':
        return restaurant;
      default:
        return others;
    }
  }
}
