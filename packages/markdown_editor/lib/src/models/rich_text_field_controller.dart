import 'dart:ui';

import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/72361282/how-to-create-a-rich-text-input-like-telegram-or-whatsapp-chat-page-in-flutter
class RichTextFieldController extends TextEditingController {
  late final Pattern pattern;
  String pureText = '';
  final Map<String, TextStyle> map = {
    r'@.\w+': const TextStyle(color: Colors.blue),
    r'#.\w+': const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    r'\*\*(.*?)\*\*': const TextStyle(fontWeight: FontWeight.bold),
    r'__(.*?)__': const TextStyle(fontStyle: FontStyle.italic),
    '~~(.*?)~~': const TextStyle(decoration: TextDecoration.lineThrough),
    r'```(.*?)```': const TextStyle(
      fontFamily: 'mono',
      fontFeatures: [FontFeature.tabularFigures()],
    ),
    r'`(#{1}\s)(.*)`': const TextStyle(color: Colors.red)
  };

  RichTextFieldController() {
    pattern = RegExp(map.keys.map((key) => key).join('|'), multiLine: true);
  }

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
    final children = <InlineSpan>[];
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
          // formattedText = match[0]!.replaceAll('**', '');
          // selection = TextSelection(baseOffset: 1, extentOffset: 1);
          textPattern = patterns[2];
        } else if (RegExp(patterns[3]).hasMatch(match[0]!)) {
          // formattedText = match[0]!.replaceAll('__', '');
          textPattern = patterns[3];
        } else if (RegExp(patterns[4]).hasMatch(match[0]!)) {
          // formattedText = match[0]!.replaceAll('~~', '');
          textPattern = patterns[4];
        } else if (RegExp(patterns[5]).hasMatch(match[0]!)) {
          // formattedText = match[0]!.replaceAll('```', '');
          textPattern = patterns[5];
        }
        children.add(
          TextSpan(
            text: formattedText,
            style: style!.merge(map[textPattern!]),
          ),
        );
        return '';
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return '';
      },
    );

    return TextSpan(style: style, children: children);
  }
}

class CustomTextEditingController extends TextEditingController {
  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  String pureText = '';


  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final children = <InlineSpan>[];
   

    return TextSpan(style: style, children: children);
  }
}
