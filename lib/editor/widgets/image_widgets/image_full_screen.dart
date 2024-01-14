import 'dart:io';

import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';

class ImageFullScreen extends StatelessWidget {
  ImageFullScreen({super.key, required this.image});
  File image;
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 4,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Image.file(image),
      ),
    );
  }
}
