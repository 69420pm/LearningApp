import 'package:flutter/cupertino.dart';

class TextFieldController extends TextEditingController {
  List<InlineSpan> spans = [];
  Map<TextRange, InlineSpan> map = {};
  String previousText = '';
  TextSelection previousSelection = TextSelection.collapsed(offset: 0);
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final TextStyle currentStyle = style!;
    void _calculateChanges(
      TextSelection previousSelection,
      TextSelection selection,
      String previousText,
      String text,
    ) {
      if (previousSelection.start >= 0 &&
          previousSelection.end >= 0 &&
          selection.start >= 0 &&
          selection.end >= 0) {
        if (previousSelection.isCollapsed) {
          if (previousText.length > text.length) {
            print(
              "single remove: ${previousText.substring(selection.end, previousSelection.start)}",
            );
          } else {
            String textToAdd =
                text.substring(previousSelection.start, selection.end);
            int length = 0;
            for (var i = 0; i < spans.length; i++) {
              var element = spans[i];
              length += element.toPlainText().length;
              if (length - spans[i - 1].toPlainText().length <=
                      selection.start &&
                  length >= length) {}
            }
            print(
              "single add: ${text.substring(previousSelection.start, selection.end)}",
            );
          }
        } else {
          int textDelta = (previousText.length - text.length).abs();
          if (previousText.length > text.length) {
            print(
              "multi remove: ${previousText.substring(previousSelection.start, previousSelection.end)}",
            );
            print(
              "multi add: ${text.substring(previousSelection.start, selection.end)}",
            );
          } else {
            print(
              "multi add: ${text.substring(previousSelection.start, previousSelection.end + textDelta)}",
            );
          }
        }
      }
    }

    assert(
      !value.composing.isValid || !withComposing || value.isComposingRangeValid,
    );

    _calculateChanges(previousSelection, selection, previousText, text);

    // If the composing range is out of range for the current text, ignore it to
    // preserve the tree integrity, otherwise in release mode a RangeError will
    // be thrown and this EditableText will be built with a broken subtree.
    final bool composingRegionOutOfRange =
        !value.isComposingRangeValid || !withComposing;
    previousText = text;
    previousSelection = selection;
    if (composingRegionOutOfRange) {
      return TextSpan(style: style, text: text);
    }

    final TextStyle composingStyle =
        style?.merge(const TextStyle(decoration: TextDecoration.underline)) ??
            const TextStyle(decoration: TextDecoration.underline);
    return TextSpan(
      style: style,
      children: <TextSpan>[
        TextSpan(text: value.composing.textBefore(value.text)),
        TextSpan(
          style: composingStyle,
          text: value.composing.textInside(value.text),
        ),
        TextSpan(text: value.composing.textAfter(value.text)),
      ],
    );
  }

  /// Calculates the changes between two texts.
  ///
  /// This function takes in two strings, [oldText] and [newText], and calculates the changes between them.
  /// The changes are represented as a list of maps, where each map contains the following keys:
  /// - 'type': The type of change, which can be 'remove' or 'add'.
  /// - 'text': The text that was removed or added.
  /// - 'start': The starting index of the change.
  ///
  /// The function iterates over the characters of both texts simultaneously, comparing them. If a difference is found,
  /// it calculates the extent of the difference and adds a map to the [changes] list.
  ///
  /// If there are remaining characters in either text after the iteration, a map is added to the [changes] list
  /// to represent the remaining text.
  ///
  /// The function returns the list of changes.
  List<Map<String, dynamic>> _calcukklateChanges(
      String oldText, String newText) {
    List<Map<String, dynamic>> changes = [];
    int oldIndex = 0, newIndex = 0;

    while (oldIndex < oldText.length && newIndex < newText.length) {
      if (oldText[oldIndex] != newText[newIndex]) {
        int startOld = oldIndex, startNew = newIndex;

        // Find the extent of the difference
        while (oldIndex < oldText.length &&
            newIndex < newText.length &&
            oldText[oldIndex] != newText[newIndex]) {
          oldIndex++;
          newIndex++;
        }

        if (startOld < oldIndex) {
          changes.add({
            'type': 'remove',
            'text': oldText.substring(startOld, oldIndex),
            'start': startOld,
          });
        }

        if (startNew < newIndex) {
          changes.add({
            'type': 'add',
            'text': newText.substring(startNew, newIndex),
            'start': startNew,
          });
        }
      } else {
        oldIndex++;
        newIndex++;
      }
    }

    if (oldIndex < oldText.length) {
      changes.add({
        'type': 'remove',
        'text': oldText.substring(oldIndex),
        'start': oldIndex,
      });
    }

    if (newIndex < newText.length) {
      changes.add({
        'type': 'add',
        'text': newText.substring(newIndex),
        'start': newIndex,
      });
    }

    return changes;
  }
}
