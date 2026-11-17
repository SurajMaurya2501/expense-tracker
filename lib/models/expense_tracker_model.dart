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
    final category = json['category'];
    final merchant = json['merchant_name'];
    final amount = json['total_amount'];
    return ExpenseTrackerModel(
      isBill: json['is_bill'] == true,
      category: category is String && category.trim().isNotEmpty
          ? category
          : 'Others',
      merchantName: merchant is String && merchant.trim().isNotEmpty
          ? merchant
          : '-',
      totalAmount: amount is num ? amount.toDouble() : 0,
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
