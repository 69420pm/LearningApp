import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class ImageHelper {
  /// pick image with opening camera app
  static Future<File?> pickImageCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) return null;
    return File(pickedImage.path);
  }

  /// pick image with opening gallery app
  static Future<File?> pickImageGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return null;
    return File(pickedImage.path);
  }

}