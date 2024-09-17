// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:learning_app/features/editor/presentation/editor_input_formatter.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field_manager.dart';

class EditorTextFieldController extends TextEditingController {
  EditorTextFieldManager em;
  EditorInputFormatter inputFormatter;
  EditorTextFieldController({required this.em, required this.inputFormatter});
  String previousText = '';
  TextSelection previousSelection = TextSelection.collapsed(offset: 0);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    inputFormatter.lastSelection = selection;
    if (selection != previousSelection &&
        (text == previousText ||
            text.characters.length < previousText.characters.length)) {
      inputFormatter.changeStyleAccordingToSelection(selection.start, context);
    }
    previousSelection = selection;
    previousText = text;
    return TextSpan(children: List.from(em.spans));
  }
}
