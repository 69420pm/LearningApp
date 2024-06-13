import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';

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
    final TextStyle currentStyle = style!.copyWith(
      fontWeight: context.read<EditorCubit>().isBold
          ? FontWeight.bold
          : FontWeight.normal,
      fontStyle: context.read<EditorCubit>().isItalic
          ? FontStyle.italic
          : FontStyle.normal,
      decoration: context.read<EditorCubit>().isUnderlined
          ? TextDecoration.underline
          : TextDecoration.none,
    );

    assert(
      !value.composing.isValid || !withComposing || value.isComposingRangeValid,
    );
    // if (text != previousText) {
    //   _calculateChanges(
    //       previousSelection, selection, previousText, text, currentStyle);
    // }
    if (text != previousText) {
      _compareStrings(previousText, text, currentStyle);
    }
    previousText = text;
    previousSelection = selection;
    // if (spans.isNotEmpty) {
    //   return spans[0] as TextSpan;
    // }
    return TextSpan(children: List.from(spans));

    // If the composing range is out of range for the current text, ignore it to
    // preserve the tree integrity, otherwise in release mode a RangeError will
    // be thrown and this EditableText will be built with a broken subtree.
    final bool composingRegionOutOfRange =
        !value.isComposingRangeValid || !withComposing;

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

  /// Calculates the changes between the previous state and the current state.
  ///
  /// It checks if there is any text added or removed and updates the spans
  /// accordingly.
  ///
  /// Parameters:
  /// - previousSelection: The previous selection of the text.
  /// - selection: The current selection of the text.
  /// - previousText: The previous text.
  /// - text: The current text.
  /// - style: The style of the text.
  void _calculateChanges(
      TextSelection previousSelection,
      TextSelection selection,
      String previousText,
      String text,
      TextStyle style) {
    // Check if the previous selection was collapsed and there is no text added
    if (previousSelection.start >= 0 &&
        previousSelection.end >= 0 &&
        selection.start >= 0 &&
        selection.end >= 0) {
      if (previousSelection.isCollapsed) {
        if (previousText.length > text.length) {
          // Text was removed
          // print(
          //   "single remove: ${previousText.substring(selection.end, previousSelection.start)}",
          // );
          // _addString('', selection.end, style, previousSelection.start);
        } else {
          String textToAdd =
              text.substring(previousSelection.start, selection.end);
          int length = 0;
          for (var i = 0; i < spans.length; i++) {
            var element = spans[i];
            length += element.toPlainText().length;
            if (i < spans.length - 1 &&
                length - spans[i - 1].toPlainText().length <= selection.start &&
                length >= length) {}
          }
          // _addString(textToAdd, previousSelection.start, style);
          // print(
          //   "single add: $textToAdd",
          // );
        }
      } else {
        int textDelta = (previousText.length - text.length).abs();
        if (previousText.length > text.length) {
          // Text was removed
          // _addString(text.substring(previousSelection.start, selection.end),
          //     previousSelection.start, style, previousSelection.end);

          // print(
          //   "multi remove: ${previousText.substring(previousSelection.start, previousSelection.end)}",
          // );
          // print(
          //   "multi add: ${text.substring(previousSelection.start, previousSelection.end + textDelta)}",
          // );
        } else {
          // Text was added
          // print(
          //   "multi add: ${text.substring(previousSelection.start, previousSelection.end + textDelta)}",
          // );
        }
      }
    }
  }

  void _compareStrings(String oldText, String newText, [TextStyle? style]) {
    final dmp = DiffMatchPatch();
    List<Diff> diffs = dmp.diff(oldText, newText);
    int startIndex = 0;
    for (Diff diff in diffs) {
      switch (diff.operation) {
        case DIFF_INSERT:
          print("Added: ${diff.text}");
          _addString(diff.text, startIndex, style);
          break;
        case DIFF_DELETE:
          print("Removed: ${diff.text}");
          _addString('', startIndex, style, startIndex + diff.text.length);
          break;
        case DIFF_EQUAL:
          print("Unchanged: ${diff.text}");
          break;
      }
      if (diff.operation != DIFF_DELETE) {
        startIndex += diff.text.length;
      }
    }
  }

  void _addString(String text, int start, [TextStyle? currentStyle, int? end]) {
    print(start);
    int length = 0;
    int previousLength = 0;
    if (spans.isEmpty) {
      spans.add(TextSpan(text: text, style: currentStyle));
      return;
    }
    for (int i = 0; i < spans.length; i++) {
      previousLength = length;
      length += spans[i].toPlainText().length;
      if (start == 0) {
        // before span
        if (currentStyle == spans[i].style) {
          spans[i] = TextSpan(
              text: text + spans[i].toPlainText().substring(end ?? 0),
              style: currentStyle);
          return;
        }
      } else if (start >= length - spans[i].toPlainText().length &&
          start < length) {
        if (currentStyle == spans[i].style) {
          spans[i] = TextSpan(
              text:
                  spans[i].toPlainText().substring(0, start - previousLength) +
                      text +
                      spans[i].toPlainText().substring(end != null
                          ? end - previousLength
                          : start - previousLength),
              style: currentStyle);
          return;
        } else {
          final wrappingStyle = spans[i].style;
          final textBefore =
              spans[i].toPlainText().substring(0, start - previousLength);
          final textAfter = spans[i].toPlainText().substring(
              end != null ? end - previousLength : start - previousLength);
          spans[i] = TextSpan(text: textBefore, style: wrappingStyle);
          spans.insert(i + 1, TextSpan(text: text, style: currentStyle));
          spans.insert(i + 2, TextSpan(text: textAfter, style: wrappingStyle));
          return;
        }
        // in span
      } else if (i == spans.length - 1) {
        // after span
        if (currentStyle == spans[i].style) {
          spans[i] = TextSpan(
              text: spans[i].toPlainText() + text, style: currentStyle);
          return;
        } else {
          spans.add(TextSpan(text: text, style: currentStyle));
          return;
        }
      }
    }
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
