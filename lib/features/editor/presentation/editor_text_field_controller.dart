// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:learning_app/features/editor/presentation/editor_input_formatter.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field_manager.dart';

class EditorTextFieldController extends TextEditingController {
  EditorTextFieldManager em;
  EditorTextFieldController({required this.em, required this.inputFormatter});
  EditorInputFormatter inputFormatter;
  String previousText = '';
  TextSelection previousSelection = TextSelection.collapsed(offset: 0);
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    inputFormatter.lastSelection = selection;

    previousSelection = selection;
    previousText = text;
    return super.buildTextSpan(
        context: context, style: style, withComposing: withComposing);
  }
}
