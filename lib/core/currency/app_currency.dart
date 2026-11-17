class AppCurrency {
  const AppCurrency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.region,
  });

  final String code;
  final String name;
  final String symbol;
  final String region;

  static const usd = AppCurrency(
    code: 'USD',
    name: 'US Dollar',
    symbol: r'$',
    region: 'United States',
  );

  static const inr = AppCurrency(
    code: 'INR',
    name: 'Indian Rupee',
    symbol: '₹',
    region: 'India',
  );

  static const eur = AppCurrency(
    code: 'EUR',
    name: 'Euro',
    symbol: '€',
    region: 'Europe',
  );

  static const gbp = AppCurrency(
    code: 'GBP',
    name: 'British Pound',
    symbol: '£',
    region: 'United Kingdom',
  );

  static const values = <AppCurrency>[usd, inr, eur, gbp];

  static AppCurrency byCode(String? code) {
    for (final currency in values) {
      if (currency.code == code) return currency;
    }
    return usd;
  }
}
