import 'package:expense_tracker/core/currency/app_currency.dart';
import 'package:intl/intl.dart';

class MoneyFormat {
  static AppCurrency currency = AppCurrency.usd;
  static final _format = NumberFormat('#,##0.00', 'en_US');

  static void use(AppCurrency value) {
    currency = value;
  }

  static String format(double amount) =>
      '${currency.symbol}${_format.format(amount)}';

  static double? tryParse(String raw) {
    var cleaned = raw.trim();
    for (final item in AppCurrency.values) {
      cleaned = cleaned.replaceAll(item.symbol, '');
    }
    cleaned = cleaned.replaceAll(',', '');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }
}
