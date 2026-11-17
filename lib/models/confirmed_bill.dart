class ConfirmedBill {
  const ConfirmedBill({
    required this.category,
    required this.merchantName,
    required this.amount,
    required this.expenseDate,
  });

  final String category;
  final String merchantName;
  final double amount;
  final DateTime expenseDate;
}
