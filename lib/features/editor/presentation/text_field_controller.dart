import 'dart:math';

import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';

class TextFieldController extends TextEditingController {
  List<InlineSpan> spans = [];
  String previousText = '';
  TextStyle previousStyle = TextStyle();
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final TextStyle currentStyle = style!.copyWith(
      fontWeight:
          context.read<EditorCubit>().isBold == true ? FontWeight.bold : null,
      fontStyle: context.read<EditorCubit>().isItalic == true
          ? FontStyle.italic
          : null,
      decoration: context.read<EditorCubit>().isUnderlined == true
          ? TextDecoration.underline
          : null,
    );
    // final TextEditorStyle currentStyle =
    //     EditorTextStyleToTextStyle.textStyleToEditorTextStyle(style!).copyWith(
    //   isBold: context.read<EditorCubit>().isBold == true ? true : null,
    //   isItalic: context.read<EditorCubit>().isItalic == true ? true : null,
    //   isUnderlined:
    //       context.read<EditorCubit>().isUnderlined == true ? true : null,
    // );

    assert(
      !value.composing.isValid || !withComposing || value.isComposingRangeValid,
    );

    if (text != previousText) {
      _compareStrings(
        previousText,
        text,
        selection,
        currentStyle,
      );
    } else if (currentStyle != previousStyle && !selection.isCollapsed) {
      _changeStaticStyle(
        TextStyle(
          fontWeight: context.read<EditorCubit>().isBold !=
                  (previousStyle.fontWeight == FontWeight.bold)
              ? context.read<EditorCubit>().isBold
                  ? FontWeight.bold
                  : FontWeight.normal
              : null,
          fontStyle: context.read<EditorCubit>().isItalic !=
                  (previousStyle.fontStyle == FontStyle.italic)
              ? context.read<EditorCubit>().isItalic
                  ? FontStyle.italic
                  : FontStyle.normal
              : null,
          decoration: context.read<EditorCubit>().isUnderlined !=
                  (previousStyle.decoration == TextDecoration.underline)
              ? context.read<EditorCubit>().isUnderlined
                  ? TextDecoration.underline
                  : TextDecoration.none
              : null,
        ),
        selection,
      );
      _reduceTextSpans();
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
      if (length > selectionStart) {
        // selection goes over current span
        if (length < selection.end) {
          String currentText = spans[i].toPlainText();
          if (selectionStart - previousLength > 0) {
            spans[i] = TextSpan(
              text: currentText.substring(
                0,
                selectionStart - previousLength,
              ),
              style: spans[i].style,
            );
            spans.insert(
              i + 1,
              TextSpan(
                text: currentText.substring(
                  selectionStart - previousLength,
                ),
                style: spans[i].style!.merge(style),
              ),
            );
            i += 1;
          } else {
            spans[i] = TextSpan(
              text: currentText.substring(
                selectionStart - previousLength,
              ),
              style: spans[i].style!.merge(style),
            );
          }

          selectionStart = length;
        } else {
          int addCount = 0;
          String currentText = spans[i].toPlainText();
          TextStyle currentStyle = spans[i].style!;
          if (selectionStart - previousLength > 0) {
            spans[i] = TextSpan(
              text: currentText.substring(
                0,
                selectionStart - previousLength,
              ),
              style: spans[i].style,
            );
            spans.insert(
              i + 1,
              TextSpan(
                text: currentText.substring(
                  selectionStart - previousLength,
                  selection.end - previousLength,
                ),
                style: spans[i].style!.merge(style),
              ),
            );
            addCount += 2;
          } else {
            spans[i] = TextSpan(
              text: currentText.substring(
                selectionStart - previousLength,
                selection.end - previousLength,
              ),
              style: spans[i].style!.merge(style),
            );
            addCount += 1;
          }

          if (selection.end - previousLength != currentText.length) {
            spans.insert(
              i + addCount,
              TextSpan(
                text: currentText.substring(
                  selection.end - previousLength,
                ),
                style: currentStyle,
              ),
            );
            addCount += 1;
          }

          i += addCount - 1;

          return;
        }
      }
    }

    // int length = 0;
    // for (int i = 0; i < spans.length; i++) {
    //   length += spans[i].toPlainText().length;
    // }
  }

  void _compareStrings(
    String oldText,
    String newText,
    TextSelection selection, [
    TextStyle? style,
  ]) {
    final dmp = DiffMatchPatch();
    // compares two strings and returns insertions and deletions
    List<Diff> diffs = dmp.diff(oldText, newText);
    int startIndex = 0;
    int changeStart = -1;
    int changeEnd = -1;
    //! bug when using equal characters with different formatting, the dmp.diff function
    //! can't detect this, because it doesn't know the formatting
    for (Diff diff in diffs) {
      switch (diff.operation) {
        case DIFF_INSERT:
          if (startIndex != selection.start - diff.text.length) {
            print("offset");
          }
          if (diff.text.contains('\n')) {
            print("newline");
          }
          _addString(diff.text, startIndex, style);
          break;
        case DIFF_DELETE:
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
            text: spans[i].toPlainText().substring(0, start - previousLength) +
                spans[i].toPlainText().substring(
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
                i + 2,
                TextSpan(text: textAfter, style: wrappingStyle),
              );
            }
          } catch (e) {
            print("err");
          }

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

  void _reduceTextSpans() {
    if (spans.length <= 1) {
      return;
    }
    for (int i = 1; i < spans.length; i++) {
      final currentStyle = spans[i].style;
      final previousStyle = spans[i - 1].style;

      if (currentStyle == previousStyle) {
        spans[i - 1] = TextSpan(
          text: spans[i - 1].toPlainText() + spans[i].toPlainText(),
          style: currentStyle,
        );
        spans.removeAt(i);
        i -= 1;
      }
    }
  }
}
