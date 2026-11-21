import 'package:expense_tracker/core/currency/app_currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const onboardingDoneKey = 'onboarding_done';
  static const currencyCodeKey = 'currency_code';
  static const remindersEnabledKey = 'reminders_enabled';

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

  /// Daily reminder notifications are on unless the user turned them off.
  static Future<bool> remindersEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(remindersEnabledKey) ?? true;
  }

  static Future<void> setRemindersEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(remindersEnabledKey, enabled);
  }

  static Future<void> saveCurrency(AppCurrency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(currencyCodeKey, currency.code);
    await prefs.setBool(onboardingDoneKey, true);
  }
}
