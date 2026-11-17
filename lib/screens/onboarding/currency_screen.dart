import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/currency/app_currency.dart';
import 'package:expense_tracker/core/prefs/app_prefs.dart';
import 'package:expense_tracker/core/utils/money_format.dart';
import 'package:expense_tracker/screens/shell/app_shell.dart';
import 'package:flutter/material.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  AppCurrency _selected = AppCurrency.usd;
  bool _saving = false;

  Future<void> _continue() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await AppPrefs.saveCurrency(_selected);
      MoneyFormat.use(_selected);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AppShell()),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save that currency.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Which currency should your bills use?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This only changes the symbol. Amounts stay on this phone.',
                style: TextStyle(color: AppColors.mainTextColor2, height: 1.4),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppCurrency.values.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final currency = AppCurrency.values[index];
                    return _CurrencyCard(
                      currency: currency,
                      selected: currency.code == _selected.code,
                      tilt: index.isEven ? -0.22 : 0.22,
                      onTap: () => setState(() => _selected = currency),
                    );
                  },
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _continue,
                  child: Text(_saving ? 'Saving...' : 'Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  const _CurrencyCard({
    required this.currency,
    required this.selected,
    required this.tilt,
    required this.onTap,
  });

  final AppCurrency currency;
  final bool selected;
  final double tilt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0016)
      ..rotateY(selected ? 0 : tilt);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        width: 168,
        transform: transform,
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: selected
                ? const [Color(0xFF3A465F), Color(0xFF1B2339)]
                : const [Color(0xFF243056), Color(0xFF151B2E)],
          ),
          border: Border.all(
            color: selected
                ? AppColors.coinGold
                : Colors.white.withValues(alpha: 0.08),
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppColors.coinGold.withValues(alpha: 0.28)
                  : Colors.black26,
              blurRadius: selected ? 18 : 8,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currency.symbol,
              style: TextStyle(
                fontSize: selected ? 52 : 44,
                fontWeight: FontWeight.w800,
                color: AppColors.coinGold,
                height: 1,
              ),
            ),
            const Spacer(),
            Text(
              currency.code,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              currency.name,
              maxLines: 2,
              style: const TextStyle(color: AppColors.mainTextColor2),
            ),
            const SizedBox(height: 2),
            Text(
              currency.region,
              style: const TextStyle(
                color: AppColors.mainTextColor3,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
