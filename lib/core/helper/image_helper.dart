import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_app/core/errors/failures/failure.dart';

class ImageHelper {
  ImageHelper(
      {required ImagePicker imagePicker, required ImageCropper imageCropper})
      : _imageCropper = imageCropper,
        _imagePicker = imagePicker;
  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  Future<Either<Failure, XFile>> pickImageFromGallery() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        return left(ImagePickingFailure(errorMessage: 'No image selected'));
      } else {
        return right(XFile(pickedFile.path));
      }
    } catch (e) {
      return left(ImagePickingFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, XFile>> pickImageFromCamera() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) {
        return left(ImagePickingFailure(errorMessage: 'No image selected'));
      } else {
        return right(XFile(pickedFile.path));
      }
    } catch (e) {
      return left(ImagePickingFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, CroppedFile>> cropImage({required XFile image}) async {
    try {
      final croppedFile =
          await _imageCropper.cropImage(sourcePath: image.path, uiSettings: []);
      if (croppedFile == null) {
        return left(ImageCroppingFailure(errorMessage: 'No image selected'));
      } else {
        return right(croppedFile);
      }
    } catch (e) {
      return left(ImageCroppingFailure(errorMessage: e.toString()));
    }
  }
}
