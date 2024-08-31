import 'dart:math';

import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field_manager.dart';

class EditorInputFormatter extends TextInputFormatter {
  EditorTextFieldManager em;
  EditorInputFormatter({required this.em});
  List<SpanFormatType> currentStyle = [];
  // gets updated in editor_cubit.dart
  LineFormatType currentLineFormat = LineFormatType.body;
  TextSelection lastSelection = TextSelection.collapsed(offset: 0);

  void changeLineFormat() {
    if (!lastSelection.isCollapsed) {
      _changeStyle(currentStyle, lastSelection.start, lastSelection.end);
      print(em.lines);
    }
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    _compareStrings(
      oldValue.text,
      newValue.text,
      newValue.selection,
    );
    lastSelection = newValue.selection;
    return newValue;
  }

  void _compareStrings(
    String oldText,
    String newText,
    TextSelection selection,
  ) {
    final dmp = DiffMatchPatch();
    // compares two strings and returns insertions and deletions
    List<Diff> diffs = dmp.diff(oldText, newText);
    int globalIndex = 0;
    int lineIndex = 0;
    int localIndex = 0;
    //! bug when using equal characters with different formatting, the dmp.diff function
    //! can't detect this, because it doesn't know the formatting
    for (Diff diff in diffs) {
      try {
        switch (diff.operation) {
          case DIFF_INSERT:
            List<String> lines = diff.text.split('\n');
            for (int i = 0; i < lines.length; i++) {
              String line = lines[i];
              if (i != 0) {
                localIndex = 0;
              }
              if (line.characters.isNotEmpty) {
                _addSpan(
                  EditorSpan(
                    span: TextSpan(text: line),
                    start: localIndex,
                    end: localIndex + line.characters.length,
                    spanFormatType: currentStyle,
                  ),
                  lineIndex + i,
                  globalIndex,
                );
              }

              globalIndex += line.characters.length;
              localIndex += line.characters.length;
            }
            break;
          case DIFF_DELETE:
            List<String> lines = diff.text.split('\n');
            for (int i = 0; i < lines.length; i++) {
              String line = lines[i];
              if (i != 0) {
                localIndex = 0;
              }
              if (line.characters.isNotEmpty) {
                _removeSpan(localIndex, localIndex + line.characters.length,
                    lineIndex + i);
              }
            }
            break;
          case DIFF_EQUAL:
            List<String> lines = diff.text.split('\n');
            lineIndex += lines.length - 1;
            if (lines.length > 1) {
              localIndex = lines[lines.length - 1].characters.length;
            } else {
              localIndex += diff.text.characters.length;
            }
            globalIndex += diff.text.characters.length;
            break;
        }
      } catch (e) {
        print(e);
      }
    }
    print(em.lines);
  }

  // start and end is line relative
  void _addSpan(EditorSpan span, int line, int globalStart) {
    if (em.lines.length <= line) {
      em.lines.add(
        EditorLine(
          spans: [span],
          start: globalStart,
          end: globalStart + span.span.toPlainText().length,
          lineFormatType: currentLineFormat,
        ),
      );
      _updateGlobalLineIndexes();
    } else if (em.lines[line].spans.isEmpty) {
      em.lines[line].spans.add(span);
      _updateGlobalLineIndexes();
    } else {
      // iterate over all spans in the line
      for (int i = 0; i < em.lines[line].spans.length; i++) {
        // if the span is in the bounds of the em.lines[i].spans[i]
        if ((em.lines[line].spans[i].end >= span.end &&
                em.lines[line].spans[i].start <= span.start) ||
            i == em.lines[line].spans.length - 1) {
          // change lineFormatType accordingly
          em.lines[line].lineFormatType = currentLineFormat;
          final before = em.lines[line].spans[i].span
              .toPlainText()
              .substring(0, span.start - em.lines[line].spans[i].start);
          final oldSpanStyle = em.lines[line].spans[i].spanFormatType;
          final inBetween = span.span.toPlainText();
          final after = em.lines[line].spans[i].span
              .toPlainText()
              .substring(span.start - em.lines[line].spans[i].start);
          if (listEquals(oldSpanStyle, span.spanFormatType)) {
            // merge the spans
            em.lines[line].spans[i] = EditorSpan(
              span: TextSpan(
                text: before + inBetween + after,
              ),
              start: em.lines[line].spans[i].start,
              end: em.lines[line].spans[i].end + inBetween.characters.length,
              spanFormatType: oldSpanStyle,
            );
          } else {
            if (before.characters.isNotEmpty) {
              // split the span and insert new span in between
              em.lines[line].spans[i] = EditorSpan(
                span: TextSpan(
                  text: before,
                ),
                start: em.lines[line].spans[i].start,
                end: em.lines[line].spans[i].start + before.characters.length,
                spanFormatType: oldSpanStyle,
              );
            } else {
              em.lines[line].spans.removeAt(i);
              i--;
            }
            if (inBetween.characters.isNotEmpty) {
              em.lines[line].spans.insert(
                i + 1,
                EditorSpan(
                  span: TextSpan(text: inBetween),
                  start:
                      em.lines[line].spans[i].start + before.characters.length,
                  end: em.lines[line].spans[i].start +
                      before.characters.length +
                      inBetween.characters.length,
                  spanFormatType: span.spanFormatType,
                ),
              );
              i++;
            }
            if (after.characters.isNotEmpty) {
              em.lines[line].spans.insert(
                i + 1,
                EditorSpan(
                  span: TextSpan(text: after),
                  start: em.lines[line].spans[i].start +
                      before.characters.length +
                      inBetween.characters.length,
                  end: em.lines[line].spans[i].start +
                      before.characters.length +
                      inBetween.characters.length +
                      after.characters.length,
                  spanFormatType: oldSpanStyle,
                ),
              );
              i++;
            }
          }
          _updateGlobalLineIndexes();
          break;
        }
      }
    }
  }

  void _updateGlobalLineIndexes() {
    int previousEnd = 0;
    em.lines[0].end = previousEnd;
    for (int i = 0; i < em.lines.length; i++) {
      if (em.lines[i].spans.isNotEmpty) {
        em.lines[i].start = previousEnd;
        em.lines[i].end = previousEnd + em.lines[i].spans.last.end;
        previousEnd = em.lines[i].end;
      }
    }
  }

  void _removeSpan(int start, int end, int line) {
    int replaceSpan(
      int start,
      String text,
      int i,
      List<SpanFormatType> styles,
    ) {
      if (text.isEmpty) {
        em.lines[line].spans.removeAt(i);
        i--;
        // merge with next span if possible
        if (i >= 0 && i < em.lines[line].spans.length - 1) {
          final currentSpan = em.lines[line].spans[i];
          final nextSpan = em.lines[line].spans[i + 1];
          if (listEquals(
            currentSpan.spanFormatType,
            nextSpan.spanFormatType,
          )) {
            em.lines[line].spans[i] = EditorSpan(
              span: TextSpan(
                text: currentSpan.span.toPlainText() +
                    nextSpan.span.toPlainText(),
              ),
              start: currentSpan.start,
              end: nextSpan.end,
              spanFormatType: currentSpan.spanFormatType,
            );
            em.lines[line].spans.removeAt(i + 1);
            i--;
          }
        }
        return i;
      } else {
        em.lines[line].spans[i] = EditorSpan(
          span: TextSpan(text: text),
          start: start,
          end: start + text.length,
          spanFormatType: styles,
        );
        return i;
      }
    }

    int alreadyDeletedOverhang = 0;
    for (int i = 0; i < em.lines[line].spans.length; i++) {
      int currentStart = em.lines[line].spans[i].start - alreadyDeletedOverhang;
      int currentEnd = em.lines[line].spans[i].end - alreadyDeletedOverhang;

      if (currentStart <= start && start <= currentEnd) {
        final currentStyle = em.lines[line].spans[i].spanFormatType;
        int localStart = start - currentStart;
        int localEnd = end - currentStart;
        String text = em.lines[line].spans[i].span.toPlainText();
        if (currentEnd >= end) {
          final editedText = text.substring(0, localStart) +
              text.substring(localEnd, text.length);
          i = replaceSpan(currentStart, editedText, i, currentStyle);
          alreadyDeletedOverhang += text.length - editedText.length;
          for (int j = i + 1; j < em.lines[line].spans.length; j++) {
            em.lines[line].spans[j].start -= alreadyDeletedOverhang;
            em.lines[line].spans[j].end -= alreadyDeletedOverhang;
          }
          _updateGlobalLineIndexes();
          break;
        } else {
          final editedText = text.substring(0, localStart);
          i = replaceSpan(currentStart, editedText, i, currentStyle);
          alreadyDeletedOverhang += text.length - editedText.length;
          start = currentEnd - alreadyDeletedOverhang;
          end -= alreadyDeletedOverhang;
        }
      }
    }
  }

  void _changeStyle(
    List<SpanFormatType> style,
    int globalStart,
    int globalEnd,
  ) {
    int globalIndex = 0;
    for (int lineIndex = 0; lineIndex < em.lines.length; lineIndex++) {
      final line = em.lines[lineIndex];
      if (globalStart >= globalIndex &&
          line.spans.isNotEmpty &&
          globalStart <= globalIndex + line.spans.last.end) {
        for (int spanIndex = 0; spanIndex < line.spans.length; spanIndex++) {
          int currentStart = line.spans[spanIndex].start + globalIndex;
          int currentEnd = line.spans[spanIndex].end + globalIndex;
          if (currentStart <= globalStart && globalStart < currentEnd) {
            final before = line.spans[spanIndex].span
                .toPlainText()
                .substring(0, globalStart - currentStart);
            final inBetween =
                line.spans[spanIndex].span.toPlainText().substring(
                      globalStart - currentStart,
                      [currentEnd - currentStart, globalEnd - currentStart]
                          .reduce(min),
                    );
            final oldTextStyle = line.spans[spanIndex].spanFormatType;
            final oldStart = line.spans[spanIndex].start;
            if (currentEnd >= globalEnd) {
              final after = line.spans[spanIndex].span
                  .toPlainText()
                  .substring(globalEnd - currentStart);
              if (before.isNotEmpty) {
                line.spans[spanIndex] = EditorSpan(
                  span: TextSpan(text: before),
                  start: oldStart,
                  end: oldStart + before.characters.length,
                  spanFormatType: oldTextStyle,
                );
              } else {
                line.spans.removeAt(spanIndex);
                spanIndex--;
              }
              if (inBetween.isNotEmpty) {
                line.spans.insert(
                  spanIndex + 1,
                  EditorSpan(
                    span: TextSpan(text: inBetween),
                    start: oldStart + before.characters.length,
                    end: oldStart +
                        before.characters.length +
                        inBetween.characters.length,
                    spanFormatType: oldTextStyle + style,
                  ),
                );
                spanIndex++;
              }
              if (after.isNotEmpty) {
                line.spans.insert(
                  spanIndex + 1,
                  EditorSpan(
                    span: TextSpan(text: after),
                    start: line.spans[spanIndex].start +
                        after.characters.length +
                        before.characters.length,
                    end: line.spans[spanIndex].start +
                        before.characters.length +
                        inBetween.characters.length +
                        after.characters.length,
                    spanFormatType: oldTextStyle,
                  ),
                );
                spanIndex++;
              }
              break;
            } else {
              // change is in multiple spans
              if (before.isNotEmpty) {
                line.spans[spanIndex] = EditorSpan(
                  span: TextSpan(text: before),
                  start: oldStart,
                  end: oldStart + before.characters.length,
                  spanFormatType: oldTextStyle,
                );
              } else {
                line.spans.removeAt(spanIndex);
                spanIndex--;
              }
              if (inBetween.isNotEmpty) {
                line.spans.insert(
                  spanIndex + 1,
                  EditorSpan(
                    span: TextSpan(text: inBetween),
                    start: oldStart + before.characters.length,
                    end: oldStart +
                        before.characters.length +
                        inBetween.characters.length,
                    spanFormatType: oldTextStyle + style,
                  ),
                );
                spanIndex++;
              }
              globalStart = currentEnd;
            }
          }
        }
      }
      globalIndex += line.spans.last.end;
    }
  }

  void _changeStyleAccordingToSelection() {}
}
