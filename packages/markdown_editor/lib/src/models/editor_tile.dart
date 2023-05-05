import 'package:flutter/material.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:equatable/equatable.dart';

abstract class EditorTile {
  EditorTile({
    required this.focusNode,
    this.textFieldController = null,
  });
  FocusNode? focusNode;
  TextFieldController? textFieldController;
}
