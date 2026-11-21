import 'package:expense_tracker/core/constants/app_theme.dart';
import 'package:expense_tracker/core/prefs/app_prefs.dart';
import 'package:expense_tracker/core/utils/money_format.dart';
import 'package:expense_tracker/screens/splash/splash_screen.dart';
import 'package:expense_tracker/services/notification_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final geminiApi = dotenv.env['GEMINI_API_KEY'] ?? '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    providerAndroid: const AndroidDebugProvider(),
    providerApple: const AppleDebugProvider(),
  );
  await NotificationService.instance.init();
  final prefs = await AppPrefs.load();
  MoneyFormat.use(prefs.currency);
  runApp(SpendWiseApp(showOnboarding: !prefs.onboardingDone));
}

class SpendWiseApp extends StatelessWidget {
  const SpendWiseApp({super.key, required this.showOnboarding});

  final bool showOnboarding;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpendWise',
      theme: AppTheme.dark,
      home: SplashScreen(showOnboarding: showOnboarding),
    );
  }
}
