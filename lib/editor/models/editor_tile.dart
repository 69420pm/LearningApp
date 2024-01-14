import 'package:flutter/material.dart';
import 'package:learning_app/editor/models/text_field_controller.dart';

/// abstract parent class for tiles(widgets) for the markdown_editor
abstract class EditorTile {
  /// focusNode which is a reference to the focus of the tile if it is somehow focusable
  FocusNode? focusNode;

  /// controller of textfield if a textfield is existing
  TextFieldController? textFieldController;

  /// Determines whether the editorTile should be rendered exclusively
  /// or be in an editable state.
  ///
  /// For example, in renderMode, textTile is rendered as plain text,
  /// while outside renderMode, it is presented as a Textfield for editing.
  bool inRenderMode = false;
}
