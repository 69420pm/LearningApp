import 'package:flutter/material.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field_manager.dart';

class EditorController extends TextEditingController {
  EditorTextFieldManager editorTextFieldManager;
  EditorController({required this.editorTextFieldManager});
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    // TODO: implement buildTextSpan
    return super.buildTextSpan(
        context: context, style: style, withComposing: withComposing);
  }
}
