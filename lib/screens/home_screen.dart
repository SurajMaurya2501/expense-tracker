import 'dart:developer';
import 'dart:io';

import 'package:expense_tracker/core/utils/gemini_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    testBillParsing();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Future<void> testBillParsing() async {
    try {
      final byteData = await rootBundle.load(
        'assets/Detailed-Grocery-Payment-Receipt-Samples.jpg',
      );
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/test_bill.jpg');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Run your processor function
      final result = await GeminiUtility().processBillWithFirebaseAi(
        image: file,
      );

      // Print the structured result to debug console
      log(
        '${result.category}--${result.isBill}--${result.merchantName}--${result.totalAmount}',
      );
    } catch (e) {
      debugPrint('--- PARSING FAILED ---');
      debugPrint(e.toString());
    }
  }
}
