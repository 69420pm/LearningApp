import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learning_app/features/quill_editor/helper/quill_helper.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/widgets/close_button.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/widgets/color_button.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/cubit/editor_keyboard_row_cubit.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/widgets/quill_toggle_button.dart';
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
            KeyboardRowCloseButton(),
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
              icon: Icons.one_k,
              controller: controller,
            ),
            QuillToolbarToggleStyleButton(
              controller: controller,
              attribute: Attribute.ol,
            ),
            QuillToolbarToggleStyleButton(
              controller: controller,
              attribute: Attribute.ul,
            ),
            QuillToolbarToggleStyleButton(
              controller: controller,
              attribute: Attribute.codeBlock,
            ),
            QuillToolbarToggleStyleButton(
              controller: controller,
              attribute: Attribute.blockQuote,
            ),
            QuillToolbarIndentButton(
              controller: controller,
              isIncrease: true,
            ),
            QuillToolbarIndentButton(
              controller: controller,
              isIncrease: false,
            ),
          ],
        ),
      ),
    );
  }
}
