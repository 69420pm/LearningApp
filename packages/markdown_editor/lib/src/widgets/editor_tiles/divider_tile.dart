import 'package:flutter/material.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';

class DividerTile extends StatelessWidget implements EditorTile {
  DividerTile({super.key});

  @override
  FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Divider();
  }
}
