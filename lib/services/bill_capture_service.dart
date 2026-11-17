import 'dart:io';

import 'package:expense_tracker/core/utils/gemini_utility.dart';
import 'package:expense_tracker/core/utils/image_picker_utility.dart';
import 'package:expense_tracker/models/expense_tracker_model.dart';
import 'package:image_picker/image_picker.dart';

class BillDraft {
  const BillDraft({required this.analysis, required this.image});

  final ExpenseTrackerModel analysis;
  final File image;
}

class BillCaptureService {
  BillCaptureService({GeminiUtility? gemini})
    : _gemini = gemini ?? GeminiUtility();

  final GeminiUtility _gemini;

  Future<File?> pick(ImageSource source) {
    return ImagePickerUtility.pickImageFromSource(sourceType: source);
  }

  Future<BillDraft> analyze(File image) async {
    final analysis = await _gemini.processBillWithFirebaseAi(image: image);
    return BillDraft(analysis: analysis, image: image);
  }
}
