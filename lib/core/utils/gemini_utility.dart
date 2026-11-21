import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:expense_tracker/core/utils/money_format.dart';
import 'package:expense_tracker/models/expense_tracker_model.dart';
import 'package:expense_tracker/services/scan_quota_service.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:path/path.dart' as p;

class GeminiUtility {
  /// Receipt extraction does not need reasoning. Gemini 3 defaults to thinking,
  /// which is the main reason a bill sits on "reading" for several seconds.
  static final GenerativeModel _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.5-flash',
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
      maxOutputTokens: 512,
      mediaResolution: MediaResolution.medium,
      thinkingConfig: ThinkingConfig.withThinkingLevel(
        ThinkingLevel.minimal,
        includeThoughts: false,
      ),
      responseSchema: Schema.object(
        properties: {
          'is_bill': Schema.boolean(
            description: 'True only if the image is a bill or receipt.',
          ),
          'category': Schema.enumString(
            enumValues: [
              'Grocery',
              'Accesory',
              'Digital Product',
              'Restaurant',
              'Others',
            ],
          ),
          'merchant_name': Schema.string(
            description: 'Store name. Empty if unreadable.',
          ),
          'total_amount': Schema.number(
            description: 'Final amount as printed. Do not convert.',
          ),
        },
        optionalProperties: ['merchant_name'],
      ),
    ),
  );

  Future<ExpenseTrackerModel> processBillWithFirebaseAi({
    required File image,
  }) async {
    // Every attempt uses one of the device's free scans, successful or not.
    // This is outside the try block on purpose: ScanLimitReachedException and
    // ScanQuotaUnavailableException must reach the UI, not become an empty bill.
    await ScanQuotaService.instance.consume();

    try {
      final mimeType = _getMimeType(image.path);
      final imageBytes = await image.readAsBytes();
      final prompt = [
        Content.multi([
          InlineDataPart(
            mimeType,
            imageBytes,
            mediaResolution: MediaResolution.medium,
          ),
          TextPart(
            'Extract the merchant and the printed total in ${MoneyFormat.currency.name}. Do not convert.',
          ),
        ]),
      ];

      final response = await _model.generateContent(prompt);
      final jsonString = response.text;

      if (jsonString == null || jsonString.isEmpty) {
        throw Exception('Empty response received from Gemini via Firebase AI.');
      }

      final jsonResponse = jsonDecode(jsonString) as Map<String, dynamic>;
      return ExpenseTrackerModel.fromJson(jsonResponse);
    } catch (error) {
      log('Something went wrong while processing image with AI - $error');
      return ExpenseTrackerModel.empty();
    }
  }

  String _getMimeType(String filePath) {
    final ext = p.extension(filePath).toLowerCase();
    switch (ext) {
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      case '.heif':
        return 'image/heif';
      case '.gif':
        return 'image/gif';
      case '.jpg':
      case '.jpeg':
      default:
        return 'image/jpeg';
    }
  }
}
