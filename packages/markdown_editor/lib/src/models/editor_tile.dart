import 'package:flutter/material.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';

/// abstract parent class for tiles(widgets) for the markdown_editor
abstract class EditorTile {
  /// constructor with a required key and focusNode
  EditorTile({
    required this.focusNode,
    this.textFieldController,
  });

  /// focusNode which is a reference to the focus of the tile if it is somehow focusable
  FocusNode? focusNode;

  /// controller of textfield if a textfield is existing
  TextFieldController? textFieldController;
}
