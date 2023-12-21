import 'dart:io';

import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class ImageFullScreen extends StatelessWidget {
  ImageFullScreen({super.key, required this.image});
  File image;
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
                  maxScale: 4,
                  minScale: 0.3,
                  panEnabled: false,
                  child: GestureDetector(
                    onVerticalDragStart: (details) => Navigator.of(context).pop(),
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.all(UIConstants.itemPadding),
                      child: Image.file(image),
                    ),
                  ),
                );
  }
}