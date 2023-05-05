import 'package:flutter/material.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';

abstract class EditorTile {
  EditorTile({
    required this.focusNode,
    this.textFieldController,
  });
  FocusNode? focusNode;
  TextFieldController? textFieldController;
}
