import 'package:flutter/material.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';

class CalloutTile extends StatelessWidget implements EditorTile {
  CalloutTile({super.key});

  @override
  FocusNode? focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: TextTile(
          focusNode: focusNode,
          textStyle: TextFieldConstants.normal,
          parentEditorTile: this,
        ),
      ),
    );
  }
}
