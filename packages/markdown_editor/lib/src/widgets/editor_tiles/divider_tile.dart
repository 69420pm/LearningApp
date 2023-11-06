import 'package:flutter/material.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:ui_components/ui_components.dart';

class DividerTile extends StatelessWidget implements EditorTile {
  DividerTile({super.key});

  @override
  FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: UIConstants.pageHorizontalPadding),
      child: Divider(color: UIColors.smallTextDark, thickness: 2,),
    );
  }

  @override
  TextFieldController? textFieldController;
  
 @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DividerTile &&
          runtimeType == other.runtimeType &&
          focusNode == other.focusNode;
}
