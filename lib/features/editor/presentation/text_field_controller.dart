import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/editor/domain/entities/text_editor_style.dart';
import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:learning_app/features/editor/presentation/helper/editor_text_style_to_text_style.dart.dart';

class TextFieldController extends TextEditingController {
  List<InlineSpan> spans = [];
  String previousText = '';
  TextEditorStyle previousStyle = TextEditorStyle();
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final TextEditorStyle currentStyle =
        EditorTextStyleToTextStyle.textStyleToEditorTextStyle(style!).copyWith(
      isBold: context.read<EditorCubit>().isBold,
      isItalic: context.read<EditorCubit>().isItalic,
      isUnderlined: context.read<EditorCubit>().isUnderlined,
    );

    assert(
      !value.composing.isValid || !withComposing || value.isComposingRangeValid,
    );

    if (text != previousText) {
      _compareStrings(
        previousText,
        text,
        EditorTextStyleToTextStyle.editorTextStyleToTextStyle(currentStyle),
      );
    } else if (currentStyle != previousStyle && !selection.isCollapsed) {
      _changeStaticStyle(
        EditorTextStyleToTextStyle.editorTextStyleToTextStyle(currentStyle),
        selection,
      );
    }
    previousText = text;
    previousStyle = currentStyle;

    return TextSpan(children: List.from(spans));
  }

  void _changeStaticStyle(TextStyle style, TextSelection selection) {
    _addString('', selection.start, style, selection.end);
    _addString(
      text.substring(selection.start, selection.end),
      selection.start,
      style,
    );

    // int length = 0;
    // for (int i = 0; i < spans.length; i++) {
    //   length += spans[i].toPlainText().length;
    // }
  }

  /// Compares two strings and generates a list of differences between them.
  ///
  /// The function uses the [DiffMatchPatch] library to calculate the differences
  /// between the [oldText] and [newText] strings. It iterates over the list of
  /// [Diff] objects and applies the appropriate operation based on the [Diff]
  /// operation type. If the operation is [DIFF_INSERT], it calls the
  /// [_addString] function to add the text to the result. If the operation is
  /// [DIFF_DELETE], it calls the [_addString] function with an empty string
  /// and the range of characters to be deleted. If the operation is [DIFF_EQUAL],
  /// it does nothing. The function updates the [startIndex] based on the length
  /// of the text for each operation.
  ///
  /// Parameters:
  /// - [oldText]: The original string to compare.
  /// - [newText]: The new string to compare.
  /// - [style]: The optional [TextStyle] to apply to the added text.
  ///
  /// Returns: None.
  void _compareStrings(String oldText, String newText, [TextStyle? style]) {
    final dmp = DiffMatchPatch();
    // compares two strings and returns insertions and deletions
    List<Diff> diffs = dmp.diff(oldText, newText);
    int startIndex = 0;
    for (Diff diff in diffs) {
      switch (diff.operation) {
        case DIFF_INSERT:
          _addString(diff.text, startIndex, style);
          break;
        case DIFF_DELETE:
          _addString('', startIndex, style, startIndex + diff.text.length);
          break;
        case DIFF_EQUAL:
          break;
      }
      if (diff.operation != DIFF_DELETE) {
        startIndex += diff.text.length;
      }
    }
  }

  /// Adds a string to the list of spans at the specified start index.
  ///
  /// The [text] parameter is the string to be added.
  /// The [start] parameter is the index at which the string should be added.
  /// The [currentStyle] parameter is an optional text style to be applied to the added string.
  /// The [end] parameter is an optional index at which the added string should end.
  ///
  /// If the spans list is empty, a new span with the specified [text] and [currentStyle] is added.
  /// If the [start] index falls within or before an existing span, the [text] is inserted into the span.
  /// If the [currentStyle] is different from the style of the existing span, the existing span is split into three parts:
  /// the part before the [start] index, the inserted [text], and the part after the [start] index.
  /// The inserted [text] is added as a new span with the specified [currentStyle].
  /// If the [start] index falls after the last span, a new span with the specified [text] and [currentStyle] is added.
  ///
  /// The function does not return anything.
  void _addString(String text, int start, [TextStyle? currentStyle, int? end]) {
    int length = 0;
    int previousLength = 0;
    if (spans.isEmpty) {
      spans.add(TextSpan(text: text, style: currentStyle));
      return;
    }
    for (int i = 0; i < spans.length; i++) {
      previousLength = length;
      length += spans[i].toPlainText().length;
      // new text should be inserted inside or before a span
      if (start >= length - spans[i].toPlainText().length && start < length) {
        if (currentStyle == spans[i].style) {
          String textBefore =
              spans[i].toPlainText().substring(0, start - previousLength);
          String textAfter = spans[i].toPlainText().substring(
                end != null ? end - previousLength : start - previousLength,
              );
          spans[i] = TextSpan(
            text: textBefore + text + textAfter,
            style: currentStyle,
          );
          return;
        } else {
          final wrappingStyle = spans[i].style;
          final textBefore =
              spans[i].toPlainText().substring(0, start - previousLength);
          final textAfter = spans[i].toPlainText().substring(
                end != null ? end - previousLength : start - previousLength,
              );
          spans[i] = TextSpan(text: textBefore, style: wrappingStyle);
          spans.insert(i + 1, TextSpan(text: text, style: currentStyle));
          spans.insert(i + 2, TextSpan(text: textAfter, style: wrappingStyle));
          return;
        }
      }
      // new text should get inserted after a span
      else if (i == spans.length - 1) {
        if (currentStyle == spans[i].style) {
          spans[i] = TextSpan(
            text: spans[i].toPlainText() + text,
            style: currentStyle,
          );
          return;
        } else {
          spans.add(TextSpan(text: text, style: currentStyle));
          return;
        }
      }
    }
  }
}
