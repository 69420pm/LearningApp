import 'dart:math';

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
        selection,
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
    print(spans.length);

    return TextSpan(children: List.from(spans));
  }

  void _changeStaticStyle(TextStyle style, TextSelection selection) {
    int selectionStart = selection.start;
    int selectionEnd = selection.end;
    int length = 0;
    int previousLength = 0;
    for (int i = 0; i < spans.length; i++) {
      previousLength = length;
      length += spans[i].toPlainText().length;
      if (length >= selectionStart) {
        // selection goes over current span
        if (length <= selection.end) {
          spans[i] = TextSpan(
            text: spans[i].toPlainText().substring(
                  0,
                  selectionStart - previousLength,
                ),
            style: spans[i].style,
          );
          spans.insert(
            i + 1,
            TextSpan(
              text: spans[i].toPlainText().substring(
                    selectionStart - previousLength,
                  ),
              style: spans[i].style!.merge(style),
            ),
          );

          selectionStart = length;
        } else {
          spans[i] = TextSpan(
            text: spans[i].toPlainText().substring(
                  0,
                  selectionStart - previousLength,
                ),
            style: spans[i].style,
          );
          spans.insert(
              i + 1,
              TextSpan(
                text: spans[i].toPlainText().substring(
                      selectionStart - previousLength,
                      selection.end - previousLength,
                    ),
                style: spans[i].style!.merge(style),
              ));
          spans.insert(
              i + 2,
              TextSpan(
                text: spans[i].toPlainText().substring(
                      selection.end - previousLength,
                    ),
                style: spans[i].style,
              ));
          return;
        }
      }
    }

    // int length = 0;
    // for (int i = 0; i < spans.length; i++) {
    //   length += spans[i].toPlainText().length;
    // }
  }

  void _compareStrings(String oldText, String newText, TextSelection selection,
      [TextStyle? style]) {
    final dmp = DiffMatchPatch();
    // compares two strings and returns insertions and deletions
    List<Diff> diffs = dmp.diff(oldText, newText);
    int startIndex = 0;
    for (Diff diff in diffs) {
      switch (diff.operation) {
        case DIFF_INSERT:
          if (startIndex != selection.start - diff.text.length) {
            print("offset");
          }
          _addString(diff.text, selection.start - diff.text.length, style);
          break;
        case DIFF_DELETE:
          // _addString('', startIndex, style, startIndex + diff.text.length);
          //! sometimes startindex is off when using autocompletion
          _removeString(startIndex, startIndex + diff.text.length);
          break;
        case DIFF_EQUAL:
          break;
      }
      if (diff.operation != DIFF_DELETE) {
        startIndex += diff.text.length;
      }
    }
  }

  void _removeString(int start, int end) {
    int length = 0;
    int previousLength = 0;
    for (int i = 0; i < spans.length; i++) {
      previousLength = length;
      length += spans[i].toPlainText().length;
      if (length >= start) {
        // selection goes over current span
        if (length <= end) {
          if (start - previousLength > 0) {
            spans[i] = TextSpan(
              text: spans[i].toPlainText().substring(
                    0,
                    start - previousLength,
                  ),
              style: spans[i].style,
            );
          } else {
            spans.removeAt(i);
            i -= 1;
          }

          start = length;
        } else {
          spans[i] = TextSpan(
            text: spans[i].toPlainText().substring(
                  end - previousLength,
                ),
            style: spans[i].style,
          );
          return;
          // try {
          //   spans.insert(
          //       i + 2,
          //       TextSpan(
          //         text: spans[i].toPlainText().substring(
          //               end - previousLength,
          //             ),
          //         style: spans[i].style,
          //       ));
          //   return;
          // } catch (e) {
          //   print(e);
          // }
        }
      }
    }
  }

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
      if (start >= previousLength && start <= length) {
        if (EditorTextStyleToTextStyle.textStyleToEditorTextStyle(
                currentStyle!) ==
            EditorTextStyleToTextStyle.textStyleToEditorTextStyle(
                spans[i].style!)) {
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
          try {
            final textAfter = spans[i].toPlainText().substring(
                  end != null ? end - previousLength : start - previousLength,
                );
            if (textBefore.isNotEmpty) {
              spans[i] = TextSpan(text: textBefore, style: wrappingStyle);
              spans.insert(i + 1, TextSpan(text: text, style: currentStyle));
            } else {
              spans[i] = TextSpan(text: text, style: currentStyle);
            }

            if (textAfter.isNotEmpty) {
              spans.insert(
                  i + 2, TextSpan(text: textAfter, style: wrappingStyle));
            }
          } catch (e) {
            print("err");
          }

          return;
        }
      }
      // new text should get inserted after a span
      else if (i == spans.length - 1) {
        if (EditorTextStyleToTextStyle.textStyleToEditorTextStyle(
                currentStyle!) ==
            EditorTextStyleToTextStyle.textStyleToEditorTextStyle(
                spans[i].style!)) {
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
