import 'dart:ui';

import 'package:flutter/material.dart';

class LatexTextFieldController extends TextEditingController {
  LatexTextFieldController() {
    pattern = RegExp(map.keys.map((key) => key).join('|'), multiLine: true);
  }
  late final Pattern pattern;
  String pureText = '';
  final Map<String, TextStyle> map = {
    r'\\([A-Za-z]+|_|&|{|}|#|!|$|%|>|\||:|;|,)': const TextStyle(color: Color.fromARGB(255, 0, 255, 0)),
    r'{|}|&': const TextStyle(color: Color.fromARGB(255, 168, 168, 168)),
    r'(?<!\\)%(.+?)(?:\r?\n|$)': const TextStyle(color: Color.fromARGB(255, 105, 105, 105)),
    r'__(.*?)__': const TextStyle(fontStyle: FontStyle.italic),
    '~~(.*?)~~': const TextStyle(decoration: TextDecoration.lineThrough),
    r'```(.*?)```': const TextStyle(
      fontFamily: 'mono',
      fontFeatures: [FontFeature.tabularFigures()],
    )
  };

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  @override
  TextSpan buildTextSpan({
    required context,
    TextStyle? style,
    required bool withComposing,
  }) {

  final List<InlineSpan> children = [];
  text.splitMapJoin(
    pattern,
    onMatch: (Match match) {
      String? formattedText;
      String? textPattern;
      final patterns = map.keys.toList();
      if (RegExp(patterns[0]).hasMatch(match[0]!)) {
        formattedText = match[0];
        textPattern = patterns[0];
      } else if (RegExp(patterns[1]).hasMatch(match[0]!)) {
        formattedText = match[0];
        textPattern = patterns[1];
      } else if (RegExp(patterns[2]).hasMatch(match[0]!)) {
        formattedText = match[0];
        textPattern = patterns[2];
      } else if (RegExp(patterns[3]).hasMatch(match[0]!)) {
        formattedText = match[0];
        textPattern = patterns[3];
      } else if (RegExp(patterns[4]).hasMatch(match[0]!)) {
        formattedText = match[0];
        textPattern = patterns[4];
      } else if (RegExp(patterns[5]).hasMatch(match[0]!)) {
        formattedText = match[0];
        textPattern = patterns[5];
      }
      children.add(TextSpan(
        text: formattedText,
        style: style!.merge(map[textPattern!]),
      ));
      return "";
    },
    onNonMatch: (String text) {
      children.add(TextSpan(text: text, style: style));
      return "";
    },
  );

  return TextSpan(style: style, children: children);
  }
}
