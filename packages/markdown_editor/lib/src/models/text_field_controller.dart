// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';

class TextFieldController extends TextEditingController {
  Map<int, CharTile> charTiles = {};
  String _previousText = '';
  TextSelection _previousSelection =
      TextSelection(baseOffset: 0, extentOffset: 0);
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final children = <InlineSpan>[];

    final isBold = context.read<TextEditorBloc>().isBold;
    final isItalic = context.read<TextEditorBloc>().isItalic;
    final isUnderlined = context.read<TextEditorBloc>().isUnderlined;

    final textDelta = text.length - _previousText.length;
    final newCharTiles = <int, CharTile>{};
    if (text == _previousText &&
        (selection.end - selection.start) > 0 &&
        selection == _previousSelection) {
      for (var i = selection.start; i < selection.end; i++) {
        charTiles[i] = CharTile(
          char: text[i],
          style: TextStyle(
            color: Colors.white,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            decoration: isUnderlined ? TextDecoration.underline : null,
          ),
        );
      }
    } else {
      for (var i = 0; i < text.length; i++) {
        if (i < selection.end) {
          if (text[i] == charTiles[i]?.char) {
            newCharTiles[i] = charTiles[i]!;
          } else {
            newCharTiles[i] = CharTile(
              char: text[i],
              style: TextStyle(
                color: Colors.white,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                decoration: isUnderlined ? TextDecoration.underline : null,
              ),
            );
          }
        } else {
          newCharTiles[i] = charTiles[i - textDelta]!;
        }
      }
      charTiles = newCharTiles;
    }

    charTiles.forEach((key, value) {
      children.add(TextSpan(text: value.char, style: value.style));
    });
    _previousText = text;
    _previousSelection = selection;

    return TextSpan(style: style, children: children);
  }
}

class CharTile {
  String char;
  TextStyle style;
  CharTile({
    required this.char,
    required this.style,
  });
}
