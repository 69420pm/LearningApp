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
    inputFormatter.lastSelection =
        _adjustSelection(previousText, text, selection);
    if (selection != previousSelection &&
        (text == previousText ||
            text.characters.length < previousText.characters.length)) {
      inputFormatter.changeStyleAccordingToSelection(selection.start, context);
    }
    previousSelection = selection;
    previousText = text;
    return TextSpan(children: List.from(em.spans));
  }

  // Adjust the selection to handle emojis and other multi-codepoint characters
  TextSelection _adjustSelection(
      String oldText, String newText, TextSelection selection) {
    // Convert both texts to Characters (grapheme clusters)
    final newChars = newText.characters;
    // when no emojis or special characters in the text
    if (newText.length == newChars.length) {
      return selection;
    }
    // Calculate the correct selection start and end positions based on grapheme clusters
    final int selectionStart =
        _adjustOffset(newText, selection.start, newChars);
    final int selectionEnd = _adjustOffset(newText, selection.end, newChars);

    return TextSelection(
        baseOffset: selectionStart, extentOffset: selectionEnd);
  }

  // Helper to adjust the offset based on grapheme clusters
  int _adjustOffset(String text, int utf16Offset, Characters characters) {
    // Convert the Characters iterable into a list of graphemes
    final graphemeList = characters.toList();

    // Iterate through the list and find the corresponding grapheme index for the UTF-16 offset
    int currentOffset = 0;
    for (int i = 0; i < graphemeList.length; i++) {
      currentOffset += graphemeList[i].length;
      if (currentOffset >= utf16Offset) {
        return i + 1; // Adjusted index based on grapheme clusters
      }
    }
    return graphemeList.length;
  }
}
