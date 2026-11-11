import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:expense_tracker/models/expense_tracker_model.dart';
import 'package:firebase_ai/firebase_ai.dart';

class GeminiUtility {
  Future<ExpenseTrackerModel> processBillWithFirebaseAi({
    required File image,
  }) async {
    try {
      final firebaseAi = FirebaseAI.googleAI();
      final model = firebaseAi.generativeModel(
        model: 'gemini-3.5-flash',
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: Schema.object(
            properties: {
              'is_bill': Schema.boolean(
                description:
                    'True if the image is a bill or receipt, false otherwise.',
              ),
              'category': Schema.enumString(
                enumValues: [
                  'Grocery',
                  'Accesory',
                  'Digital Product',
                  'Restaurant',
                  'Others',
                ],
                description: 'The category that best fits the bill.',
              ),
              'merchant_name': Schema.string(
                description: 'The store or business name issuing the bill.',
              ),
              'total_amount': Schema.number(
                description: 'The total numerical amount paid or due.',
              ),
            },
            optionalProperties: ['merchant_name'],
          ),
        ),
      );

      final imageBytes = await image.readAsBytes();
      final prompt = [
        Content.multi([
          InlineDataPart('image/jpg', imageBytes),
          TextPart(
            'Verify if this is a bill, extract the merchant and total amount, and choose a strict category.',
          ),
        ]),
      ];

      // 3. Generate response
      final response = await model.generateContent(prompt);
      final jsonString = response.text;

      if (jsonString == null || jsonString.isEmpty) {
        throw Exception('Empty response received from Gemini via Firebase AI.');
      }

      // 4. Safely decode the guaranteed JSON structure
      final jsonResponse = jsonDecode(jsonString) as Map<String, dynamic>;
      return ExpenseTrackerModel.fromJson(jsonResponse);
    } catch (error) {
      log('Something went wrong while processing image with AI - $error');
      return ExpenseTrackerModel.empty();
    }
  }
}
