import 'dart:ui';

import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor/src/models/rich_text_field_controller.dart';

class TextTile extends StatefulWidget {
  const TextTile({super.key});

  @override
  State<TextTile> createState() => _TextTileState();
}

class _TextTileState extends State<TextTile> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: RichTextFieldController(),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      onChanged: (value) {
        var new_text = value;
        var italicRegexMatch = RegExp(r'(?<!\*)\*(?![*\s])(?:[^*]*[^*\s])?\*')
            .allMatches(new_text);
        // var boldRegexMatch = RegExp(r'(\**)+(\S+)(\**)+').firstMatch(new_text);
        // print(italicRegexMatch);
        for (var match in italicRegexMatch) {
          new_text = new_text.replaceAll(RegExp(r'(?<!\*)\*(?![*\s])(?:[^*]*[^*\s])?\*'), '');
        }
        var markdown = new_text;
 markdown = markdown.replaceAll(RegExp('_(.+?)_'), '');
  markdown = markdown.replaceAll(RegExp(r'\*(.+?)\*'), '');
  print(markdown);
        // if (boldRegexMatch != null) {
        //   // print(italicRegexMatch.star
        //   // print(italicRegexMatch.end);
        //   new_text = new_text.substring(0, boldRegexMatch.start - 2) +
        //       new_text.substring(
        //           boldRegexMatch.start + 1, boldRegexMatch.end - 2) +
        //       new_text.substring(boldRegexMatch.end);
        // }
      },
    );
  }
}
