import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtility {
  static final _imagePicker = ImagePicker();

  /// Longest edge sent to the model. Receipt text stays readable, and a
  /// camera photo drops from several MB to a few hundred KB.
  static const _maxEdge = 1280.0;
  static const _jpegQuality = 72;

  static Future<File?> pickImageFromSource({
    ImageSource sourceType = ImageSource.gallery,
  }) async {
    final image = await _imagePicker.pickImage(
      source: sourceType,
      maxWidth: _maxEdge,
      maxHeight: _maxEdge,
      imageQuality: _jpegQuality,
      requestFullMetadata: false,
    );
    if (image == null) {
      return null;
    }
    final imageFile = File(image.path);
    return imageFile;
  }
}
