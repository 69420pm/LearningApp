import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learning_app/features/quill_editor/helper/quill_helper.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/color_button.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/cubit/editor_keyboard_row_cubit.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/quill_toggle_button.dart';
// import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/quill_toggle_button.dart';

class FormatLineRow extends StatelessWidget {
  FormatLineRow({super.key, required this.controller});
  QuillController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: QuillToolbar(
        child: Row(
          children: [
            QuillToggleButton(
              onSelect: () {
                controller.formatSelection(HeaderAttribute(level: 5));
              },
              onUnselect: () {
                controller.formatSelection(HeaderAttribute(level: null));
              },
              onBuild: () {
                bool isSelected = false;
                final headerAttribute =
                    controller.getSelectionStyle().attributes['header'];
                if (headerAttribute == null) {
                  isSelected = false;
                } else {
                  isSelected = headerAttribute.value == 5;
                }
                return isSelected;
              },
              icon: Icons.format_clear,
              controller: controller,
            ),
            IconButton(
                onPressed: () {
                  context.read<EditorKeyboardRowCubit>().selectNothing();
                },
                icon: Icon(Icons.arrow_back)),
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
      ),
    );
  }
}
