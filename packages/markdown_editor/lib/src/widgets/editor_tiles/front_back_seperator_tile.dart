import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:ui_components/ui_components.dart';

class FrontBackSeparatorTile extends StatelessWidget implements EditorTile {
  FrontBackSeparatorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: UIConstants.pageHorizontalPadding),
      child: Divider(
        color: UIColors.smallTextDark,
        thickness: 5,
      ),
    );
  }

  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;
}
