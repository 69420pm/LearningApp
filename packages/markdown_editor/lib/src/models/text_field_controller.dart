// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';

class TextFieldController extends TextEditingController {
  Map<int, CharTile> charTiles = {};
  String _previousText = '';
  TextSelection _previousSelection =
      TextSelection(baseOffset: 0, extentOffset: 0);

  bool _previousBold = false;
  bool _previousItalic = false;
  bool _previousUnderlined = false;
  bool _previousCode = false;
  Color _previousTextColor = Colors.white;
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
    final isCode = context.read<TextEditorBloc>().isCode;
    final textColor = KeyboardRow.returnColorFromTextColor(
      context.read<TextEditorBloc>().textColor,
    );

    final textDelta = text.length - _previousText.length;
    final newCharTiles = <int, CharTile>{};
    if (text == _previousText &&
        (selection.end - selection.start) > 0 &&
        selection == _previousSelection) {
      bool? boldToChange;
      bool? italicToChange;
      bool? underlinedToChange;
      bool? codeToChange;
      Color? textColorToChange;
      if (isBold != _previousBold) {
        boldToChange = isBold;
      }
      if (isItalic != _previousItalic) {
        italicToChange = isItalic;
      }
      if (isUnderlined != _previousUnderlined) {
        underlinedToChange = isUnderlined;
      }
      if (textColor != _previousTextColor) {
        textColorToChange = textColor;
      }
      if (codeToChange != codeToChange) {
        codeToChange = isCode;
      }
      for (var i = selection.start; i < selection.end; i++) {
        charTiles[i] = CharTile(
          char: text[i],
          style: !isCode
              ? TextStyle(
                  color: textColorToChange ?? charTiles[i]!.style.color,
                  fontWeight: boldToChange != null
                      ? boldToChange
                          ? FontWeight.bold
                          : FontWeight.normal
                      : charTiles[i]!.style.fontWeight,
                  fontStyle: italicToChange != null
                      ? italicToChange
                          ? FontStyle.italic
                          : FontStyle.normal
                      : charTiles[i]!.style.fontStyle,
                  decoration: underlinedToChange != null
                      ? underlinedToChange
                          ? TextDecoration.underline
                          : null
                      : charTiles[i]!.style.decoration,
                  background: Paint()..color = Colors.transparent,
                )
              : TextStyle(
                color: Colors.white,
                  background: Paint()..color = Colors.black,
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
              style: !isCode
                  ? TextStyle(
                      color: textColor,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                      decoration:
                          isUnderlined ? TextDecoration.underline : null,
                      background: Paint()..color = Colors.transparent,
                    )
                  : TextStyle(
                    color: Colors.white,
                      background: Paint()..color = Colors.black,
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
    _previousBold = isBold;
    _previousItalic = isItalic;
    _previousUnderlined = isUnderlined;
    _previousCode = isCode;
    _previousTextColor = textColor;

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
