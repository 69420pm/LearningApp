import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

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
              // ElevatedButton(onPressed: () {}, child: Text('color')),
              QuillToolbarHistoryButton(
                isUndo: true,
                controller: controller,
              ),
              QuillToolbarHistoryButton(
                isUndo: false,
                controller: controller,
              ),

              // QuillToolbarImageButton(
              //   controller: controller,
              // ),
              QuillToolbarClearFormatButton(
                controller: controller,
              ),
              QuillToolbarColorButton(
                controller: controller,
                isBackground: false,
              ),
              QuillToolbarToggleStyleButton(
                controller: controller,
                attribute: Attribute.ol,
              ),
              QuillToolbarSelectHeaderStyleDropdownButton(
                controller: controller,
                options:
                    const QuillToolbarSelectHeaderStyleDropdownButtonOptions(),
              ),
            ],
          ),
        ));
  }
}
