import 'package:flutter/material.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';

class ListEditorTile extends StatelessWidget implements EditorTile {
  ListEditorTile({super.key});

  @override
  FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(Icons.circle),
          Expanded(
            child: TextTile(
              textStyle: TextFieldConstants.normal,
              focusNode: focusNode,
              parentEditorTile: this,
            ),
          )
        ],
      ),
    );
  }
}
