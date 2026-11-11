enum BillCategory { grocery, accesory, digitalProduct, restaurant, others }

class ExpenseTrackerModel {
  final bool isBill;
  final String category;
  final String merchantName;
  final double totalAmount;

  ExpenseTrackerModel({
    required this.isBill,
    required this.category,
    required this.merchantName,
    required this.totalAmount,
  });

  factory ExpenseTrackerModel.empty() {
    return ExpenseTrackerModel(
      isBill: false,
      category: 'Others',
      merchantName: '-',
      totalAmount: 0.0,
    );
  }

  factory ExpenseTrackerModel.fromJson(Map<String, dynamic> json) {
    return ExpenseTrackerModel(
      isBill: json['is_bill'],
      category: json['category'],
      merchantName: json['merchant_name'],
      totalAmount: json['total_amount'],
    );
  }

  static BillCategory fromString(String? value) {
    if (value == null) return BillCategory.others;

    return BillCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => BillCategory.others, // Fallback if no match is found
    );
  }
}
