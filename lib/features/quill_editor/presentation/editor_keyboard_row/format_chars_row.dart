import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learning_app/features/quill_editor/helper/quill_helper.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/color_button.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/cubit/editor_keyboard_row_cubit.dart';

class FormatCharsRow extends StatelessWidget {
  FormatCharsRow({super.key, required this.controller});
  QuillController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: QuillToolbar(
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  context.read<EditorKeyboardRowCubit>().selectNothing();
                },
                icon: Icon(Icons.arrow_back)),
            ColorButton(controller: controller),
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
              attribute: Attribute.strikeThrough,
            ),
            QuillToolbarToggleStyleButton(
              controller: controller,
              attribute: Attribute.subscript,
            ),
            QuillToolbarToggleStyleButton(
              controller: controller,
              attribute: Attribute.superscript,
            ),
          ],
        ),
      ),
    );
  }
}
