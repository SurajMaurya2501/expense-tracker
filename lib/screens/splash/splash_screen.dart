import 'dart:async';

import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/screens/onboarding/onboarding_screen.dart';
import 'package:expense_tracker/screens/shell/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.showOnboarding});

  final bool showOnboarding;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1800), _openNext);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _openNext() {
    if (!mounted) return;
    final next = widget.showOnboarding
        ? const OnboardingScreen()
        : const AppShell();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) => next,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.menuBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_CoinMark(), SizedBox(height: 28), _Wordmark()],
        ),
      ),
    );
  }
}

class _CoinMark extends StatelessWidget {
  const _CoinMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: 132,
          height: 132,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                    width: 132,
                    height: 132,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.coinGold.withValues(alpha: 0.16),
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.08, 1.08),
                    duration: 1400.ms,
                    curve: Curves.easeInOut,
                  ),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.coinGold,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.coinInk,
                  size: 42,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(
          begin: const Offset(0.6, 0.6),
          duration: 700.ms,
          curve: Curves.easeOutBack,
        );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
              'SpendWise',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            )
            .animate()
            .fadeIn(delay: 280.ms, duration: 500.ms)
            .slideY(
              begin: 0.4,
              end: 0,
              delay: 280.ms,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),
        const SizedBox(height: 8),
        const Text(
          'See where your money goes',
          style: TextStyle(color: AppColors.mainTextColor2, fontSize: 15),
        ).animate().fadeIn(delay: 480.ms, duration: 500.ms),
      ],
    );
  }
}
