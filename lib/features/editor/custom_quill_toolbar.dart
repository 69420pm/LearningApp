import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class CustomQuillToolbar extends StatelessWidget {
  const CustomQuillToolbar({super.key, required this.controller});

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    return QuillToolbar(
        configurations: const QuillToolbarConfigurations(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            children: [
              ElevatedButton(
                  onPressed: () {
                    controller.formatSelection(
                        ColorAttribute(colorToHex(Colors.red)));
                  },
                  child: Text('color')),
              QuillToolbarHistoryButton(
                isUndo: true,
                controller: controller,
              ),
              QuillToolbarHistoryButton(
                isUndo: false,
                controller: controller,
              ),
              QuillToolbarToggleStyleButton(
                options: const QuillToolbarToggleStyleButtonOptions(),
                controller: controller,
                attribute: Attribute.bold,
              ),
              QuillToolbarToggleStyleButton(
                options: const QuillToolbarToggleStyleButtonOptions(),
                controller: controller,
                attribute: Attribute.italic,
              ),
              QuillToolbarToggleStyleButton(
                controller: controller,
                attribute: Attribute.underline,
              ),
              QuillToolbarToggleStyleButton(
                controller: controller,
                attribute: Attribute.subscript,
              ),
              QuillToolbarToggleStyleButton(
                controller: controller,
                attribute: Attribute.superscript,
              ),
              QuillToolbarImageButton(
                controller: controller,
              ),
              QuillToolbarClearFormatButton(
                controller: controller,
              ),
              QuillToolbarColorButton(
                controller: controller,
                isBackground: false,
              ),
            ],
          ),
        ));
  }
}
