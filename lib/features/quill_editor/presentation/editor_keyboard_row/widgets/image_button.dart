import 'package:flutter/material.dart';
import 'package:learning_app/core/helper/image_helper.dart';
import 'package:learning_app/injection_container.dart';

class ImageButton extends StatelessWidget {
  ImageButton({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        (await sl<ImageHelper>().pickImageFromCamera()).match((failure) {
          print(failure.errorMessage);
        }, (image) {
          final croppedImage = sl<ImageHelper>().cropImage(image: image);
        });
      },
      icon: const Icon(Icons.photo_camera_outlined),
    );
  }
}
