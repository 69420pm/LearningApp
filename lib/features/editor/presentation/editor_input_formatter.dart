import 'dart:math';

import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field_manager.dart';
import 'package:rxdart/rxdart.dart';

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
    em.generateSpans();
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
      switch (diff.operation) {
        case DIFF_INSERT:
          List<String> lines = diff.text.split('\n');
          for (int i = 0; i < lines.length; i++) {
            String line = lines[i];
            if (i != 0) {
              // line += '\n';
              line = '\n$line';
              if (localIndex != em.lines[lineIndex].spans.last.end) {
                // shift spans to next line
                for (int j = 0; j < em.lines[lineIndex].spans.length; j++) {
                  final span = em.lines[lineIndex].spans[j];
                  if (span.end >= localIndex && span.start <= localIndex) {
                    EditorSpan? previousSpan;
                    if (j > 0) {
                      previousSpan = em.lines[lineIndex].spans[j - 1];
                    }
                    final splittedSpans = splitSpan(
                      span,
                      localIndex -
                          (previousSpan != null ? previousSpan.end : 0),
                    );
                    if (splittedSpans[0] != null) {
                      em.lines[lineIndex].spans[j] = splittedSpans[0]!;
                      j++;
                    } else {
                      em.lines[lineIndex].spans.removeAt(j);
                      j--;
                    }

                    final spansToShift = em.lines[lineIndex].spans
                        .getRange(j, em.lines[lineIndex].spans.length)
                        .toList();
                    if (splittedSpans[1] != null) {
                      spansToShift.insert(0, splittedSpans[1]!);
                    }
                    int spansToShiftStart = 0;
                    for (int k = 0; k < spansToShift.length; k++) {
                      spansToShift[k].start = spansToShiftStart;
                      spansToShiftStart +=
                          spansToShift[k].span.toPlainText().characters.length;
                      spansToShift[k].end = spansToShiftStart;
                    }
                    if (em.lines.length > lineIndex) {
                      em.lines.insert(
                        lineIndex + 1,
                        EditorLine(
                          start: globalIndex,
                          end: globalIndex + spansToShift.last.end,
                          spans: spansToShift,
                        ),
                      );
                    } else {
                      em.lines[lineIndex + 1].spans.insertAll(
                        0,
                        spansToShift,
                      );
                    }

                    em.lines[lineIndex].spans
                        .removeRange(j, em.lines[lineIndex].spans.length);

                    em.lines[lineIndex].end = em.lines[lineIndex].start +
                        em.lines[lineIndex].spans.last.end;
                    break;
                  }
                }
              }
              lineIndex++;
              localIndex = 0;
            }

            if (line.isNotEmpty) {
              _addSpan(
                EditorSpan(
                  span: TextSpan(text: line),
                  start: localIndex,
                  end: localIndex + line.characters.length,
                  spanFormatType: currentStyle,
                ),
                lineIndex,
                globalIndex,
              );
            }

            globalIndex += line.characters.length;
            localIndex += line.characters.length;
          }
          break;
        case DIFF_DELETE:
          List<String> lines = diff.text.split('\n');
          int previousLineLength = 0;
          for (int i = 0; i < lines.length; i++) {
            String line = lines[i];
            if (i != 0) {
              localIndex = 0;
              line += '\n';
            }
            if (line.characters.isNotEmpty) {
              previousLineLength = em.lines.length;
              _removeSpan(
                localIndex,
                localIndex + line.characters.length,
                lineIndex + i,
              );
              lineIndex -= previousLineLength - em.lines.length;
            }
          }
          break;
        case DIFF_EQUAL:
          List<String> lines = diff.text.split('\n');
          lineIndex += lines.length - 1;
          if (lines.length > 1) {
            localIndex = lines[lines.length - 1].characters.length + 1;
          } else {
            localIndex += diff.text.characters.length;
          }
          globalIndex += diff.text.characters.length;
          break;
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
    } else if (em.lines[line].spans.isEmpty) {
      em.lines[line].spans.add(span);
    } else {
      // iterate over all spans in the line
      for (int i = 0; i < em.lines[line].spans.length; i++) {
        // if the span is in the bounds of the em.lines[i].spans[i]
        if ((em.lines[line].spans[i].end +
                        span.span.toPlainText().characters.length >=
                    span.end &&
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
            if (before.isNotEmpty) {
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
            int start = i >= 0 ? em.lines[line].spans[i].start : 0;
            if (inBetween.isNotEmpty) {
              em.lines[line].spans.insert(
                i + 1,
                EditorSpan(
                  span: TextSpan(text: inBetween),
                  start: start + before.characters.length,
                  end: start +
                      before.characters.length +
                      inBetween.characters.length,
                  spanFormatType: span.spanFormatType,
                ),
              );
              i++;
            }
            if (after.isNotEmpty) {
              em.lines[line].spans.insert(
                i + 1,
                EditorSpan(
                  span: TextSpan(text: after),
                  start: start +
                      before.characters.length +
                      inBetween.characters.length,
                  end: start +
                      before.characters.length +
                      inBetween.characters.length +
                      after.characters.length,
                  spanFormatType: oldSpanStyle,
                ),
              );
              i++;
            }
          }
          // update local indexes of following EditorSpans
          for (int j = i + 1; j < em.lines[line].spans.length; j++) {
            em.lines[line].spans[j].start += inBetween.characters.length;
            em.lines[line].spans[j].end += inBetween.characters.length;
          }
          break;
        }
      }
    }
    _updateGlobalLineIndexes();
  }

  void _updateGlobalLineIndexes() {
    int previousEnd = 0;
    em.lines[0].end = previousEnd;
    for (int i = 0; i < em.lines.length; i++) {
      if (em.lines[i].spans.isNotEmpty) {
        em.lines[i].start = previousEnd;
        em.lines[i].end = previousEnd + em.lines[i].spans.last.end;
        previousEnd = em.lines[i].end;
      } else {
        em.lines.removeAt(i);
        i--;
      }
      if (i > 0 &&
          em.lines[i].spans.isNotEmpty &&
          !em.lines[i].spans[0].span.toPlainText().startsWith('\n')) {
        final previousSpans = em.lines[i - 1].spans;
        final currentSpans = em.lines[i].spans;
        final currentSpansCharacterLength = currentSpans.last.end;
        for (final span in em.lines[i].spans) {
          span.start += previousSpans.last.end;
          span.end += previousSpans.last.end;
        }
        // merge last spans if possible
        if (listEquals(
          previousSpans.last.spanFormatType,
          currentSpans.first.spanFormatType,
        )) {
          previousSpans[previousSpans.length - 1] = EditorSpan(
            span: TextSpan(
              text: previousSpans.last.span.toPlainText() +
                  currentSpans.first.span.toPlainText(),
            ),
            start: previousSpans.last.start,
            end: previousSpans.last.end +
                currentSpans.first.span.toPlainText().characters.length,
            spanFormatType: previousSpans.last.spanFormatType,
          );
          currentSpans.removeAt(0);
        }
        em.lines[i - 1] = EditorLine(
          spans: previousSpans + currentSpans,
          start: em.lines[i - 1].start,
          end: em.lines[i - 1].end + currentSpansCharacterLength,
          lineFormatType: em.lines[i - 1].lineFormatType,
        );
        em.lines.removeAt(i);
        i--;
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
    void changeStylePerLine(int localStart, int localEnd, int line) {
      for (int j = 0; j < em.lines[line].spans.length; j++) {
        final currentSpan = em.lines[line].spans[j];
        if (localStart >= currentSpan.start) {
          String before = currentSpan.span.toPlainText().substring(
                0,
                localStart - currentSpan.start,
              );
          String inBetween = currentSpan.span.toPlainText().substring(
                localStart - currentSpan.start,
                min(localEnd - currentSpan.start, currentSpan.end),
              );
          bool inSingleSpan = false;
          if (localEnd <= currentSpan.end) {
            inSingleSpan = true;
          }
          if (listEquals(style, currentSpan.spanFormatType)) {
            // nothing to change
            return;
          }

          String after = '';
          if (inSingleSpan) {
            after = em.lines[line].spans[j].span
                .toPlainText()
                .substring(min(localEnd - currentSpan.start, currentSpan.end));
          }

          if (before.isNotEmpty) {
            em.lines[line].spans[j] = EditorSpan(
              span: TextSpan(text: before),
              start: currentSpan.start,
              end: currentSpan.start + before.characters.length,
              spanFormatType: currentSpan.spanFormatType,
            );
          } else {
            em.lines[line].spans.removeAt(j);
            j--;
          }
          if (inBetween.isNotEmpty) {
            em.lines[line].spans.insert(
              j + 1,
              EditorSpan(
                span: TextSpan(text: inBetween),
                start: currentSpan.start + before.characters.length,
                end: currentSpan.start +
                    before.characters.length +
                    inBetween.characters.length,
                spanFormatType: style,
              ),
            );
            j++;
          }
          if (after.isNotEmpty) {
            em.lines[line].spans.insert(
              j + 1,
              EditorSpan(
                span: TextSpan(text: after),
                start: currentSpan.start +
                    before.characters.length +
                    inBetween.characters.length,
                end: currentSpan.end,
                spanFormatType: currentSpan.spanFormatType,
              ),
            );
          }
          if (inSingleSpan) {
            return;
          } else {
            globalStart += inBetween.characters.length;
          }
        }
      }
    }

    int startLine = findStartLine(globalStart);
    int endLine = findStartLine(globalEnd);
    for (int i = startLine; i <= endLine; i++) {
      changeStylePerLine(
        globalStart - em.lines[i].start,
        globalEnd - em.lines[i].start,
        i,
      );
    }
  }

  void _changeStyleAccordingToSelection() {}

  /// return index of line where the index of [globalStart] is located
  int findStartLine(int globalStart) {
    for (int i = 0; i < em.lines.length; i++) {
      if (globalStart >= em.lines[i].start && globalStart <= em.lines[i].end) {
        return i;
      }
    }
    // in a new line
    return em.lines.length;
  }

  /// Splits an [EditorSpan] at a given index into two [EditorSpan]s.
  ///
  /// The first returned [EditorSpan] contains the text before the split point,
  /// the second returned [EditorSpan] contains the text after the split point.
  ///
  /// If the split point is at the start or end of the [EditorSpan], the
  /// corresponding [EditorSpan] is null.
  ///
  /// The [EditorSpan]s returned are copies of the original [EditorSpan], with
  /// the start and end adjusted according to the split point.
  ///
  /// The style of the returned [EditorSpan]s is the same as the original
  /// [EditorSpan].
  List<EditorSpan?> splitSpan(EditorSpan span, int splitPoint) {
    final leftText = span.span.toPlainText().substring(0, splitPoint);
    final rightText = span.span.toPlainText().substring(splitPoint);
    final leftSpan = leftText.isEmpty
        ? null
        : span.copyWith(
            span: TextSpan(text: leftText),
            end: span.start + splitPoint,
          );
    final rightSpan = rightText.isEmpty
        ? null
        : span.copyWith(
            span: TextSpan(text: rightText),
            start: span.start + splitPoint,
            end: span.end,
          );
    return [leftSpan, rightSpan];
  }

  List<EditorSpan> mergePotentiallySpans(
    EditorSpan leftSpan,
    EditorSpan rightSpan,
  ) {
    if (listEquals(leftSpan.spanFormatType, rightSpan.spanFormatType)) {
      final mergedSpan = leftSpan.copyWith(
        span: TextSpan(
          text: leftSpan.span.toPlainText() + rightSpan.span.toPlainText(),
        ),
        start: leftSpan.start,
        end: rightSpan.end,
      );
      return [mergedSpan];
    }
    return [leftSpan, rightSpan];
  }
}
