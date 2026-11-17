import 'package:expense_tracker/core/currency/app_currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const onboardingDoneKey = 'onboarding_done';
  static const currencyCodeKey = 'currency_code';

  final bool onboardingDone;
  final AppCurrency currency;

  const AppPrefs({required this.onboardingDone, required this.currency});

  static Future<AppPrefs> load() async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool(onboardingDoneKey) ?? false;
    final code = prefs.getString(currencyCodeKey);
    return AppPrefs(
      onboardingDone: done && code != null,
      currency: AppCurrency.byCode(code),
    );
  }

  static Future<void> saveCurrency(AppCurrency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(currencyCodeKey, currency.code);
    await prefs.setBool(onboardingDoneKey, true);
  }
}
