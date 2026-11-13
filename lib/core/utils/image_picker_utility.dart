import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtility {
  static final _imagePicker = ImagePicker();

  static Future<File?> pickImageFromSource({
    ImageSource sourceType = ImageSource.gallery,
  }) async {
    final image = await _imagePicker.pickImage(source: sourceType,);
    if (image == null) {
      return null;
    }
    final imageFile = File(image.path);
    return imageFile;
  }
}
