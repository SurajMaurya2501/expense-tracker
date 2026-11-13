import 'dart:developer';
import 'dart:io';

import 'package:expense_tracker/core/utils/gemini_utility.dart';
import 'package:expense_tracker/core/utils/image_picker_utility.dart';
import 'package:expense_tracker/local/database/app_database.dart';
import 'package:expense_tracker/local/repositories/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _expenseRepo = ExpenseRepository();
  late Stream<List<ExpenseEntity>> _expenses;

  @override
  void initState() {
    super.initState();
    _expenses = _expenseRepo.watchExpenseForMonth('11-2026');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: _expenses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No Data Available'));
                } else {
                  final data = snapshot.data ?? [];
                  return Column(
                    children: List.generate(data.length, (index) {
                      final expense = data[index];
                      return Row(
                        children: [
                          Text(expense.id.toString()),
                          Text(expense.merchantName),
                          Text(expense.category),
                          Text(expense.amount.toString()),
                          Text(expense.expenseDate.toString()),
                        ],
                      );
                    }),
                  );
                }
              },
            ),
            ElevatedButton.icon(
              onPressed: () {
                pickAndUploadBill();
              },
              label: Text('Upload'),
              icon: Icon(Icons.upload),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickAndUploadBill() async {
    final expenseRepo = ExpenseRepository();

    try {
      final today = DateTime.now();
      final formattedMonthYear = DateFormat('MM-yyyy').format(today);
      final image = await ImagePickerUtility.pickImageFromSource();
      if (image == null) return;
      log('Image picked');

      final imageFile = File(image.path);
      final result = await GeminiUtility().processBillWithFirebaseAi(
        image: imageFile,
      );
      log('Image Processed By Ai');

      await expenseRepo
          .insertExpense(
            ExpensesCompanion.insert(
              amount: result.totalAmount,
              category: result.category,
              merchantName: result.merchantName,
              expenseDate: today,
              monthYear: formattedMonthYear,
            ),
          )
          .then((value) {
            log('Data Has Inserted Into Table');
          });
      log(
        'Result - ${result.totalAmount} -- ${result.category} -- ${result.merchantName} -- $formattedMonthYear',
      );
    } catch (e) {
      debugPrint('--- PARSING FAILED ---');
      debugPrint(e.toString());
    }
  }
}
