import 'package:expense_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

// import 'package:firebase_ai/firebase_ai.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';

final geminiApi = dotenv.env['GEMINI_API_KEY'] ?? '';

Future<void> main() async {
  await dotenv.load();
  Gemini.init(apiKey: geminiApi);
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    providerAndroid: const AndroidDebugProvider(),
    providerApple: const AppleDebugProvider(),
  );
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
