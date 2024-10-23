import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/change_text_colors_row.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/cubit/editor_keyboard_row_cubit.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/format_chars_row.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/format_line_row.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/image_row.dart';

class EditorKeyboardRow extends StatelessWidget {
  EditorKeyboardRow({super.key, required this.controller});
  final QuillController controller;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorKeyboardRowCubit, EditorKeyboardRowState>(
      builder: (context, state) {
        if (state == EditorKeyboardRowNothingSelected()) {
          return Row(
            children: [
              IconButton(
                  onPressed: () {
                    context.read<EditorKeyboardRowCubit>().selectCamera();
                  },
                  icon: Icon(Icons.camera_alt_outlined)),
              IconButton(
                  onPressed: () {
                    context.read<EditorKeyboardRowCubit>().selectFormatChars();
                  },
                  icon: Icon(Icons.format_bold_rounded)),
              IconButton(
                  onPressed: () {
                    context.read<EditorKeyboardRowCubit>().selectFormatLine();
                  },
                  icon: Icon(Icons.format_list_bulleted_rounded)),
            ],
          );
        } else if (state == EditorKeyboardRowFormatChars()) {
          return FormatCharsRow(
            controller: controller,
          );
        } else if (state == EditorKeyboardRowFormatLine()) {
          return FormatLineRow(controller: controller);
        } else if (state == EditorKeyboardRowChangeTextColors()) {
          return ChangeTextColorsRow(
            controller: controller,
          );
        } else if (state == EditorKeyboardRowImage()) {
          return EmbedBlockRow(controller: controller);
        } else {
          return Text('internal error');
        }
      },
    );
  }
}
