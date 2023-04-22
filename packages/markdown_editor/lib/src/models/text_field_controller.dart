// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';

// https://medium.com/dartlang/dart-string-manipulation-done-right-5abd0668ba3e

class TextFieldController extends TextEditingController {
  TextFieldController({
    required this.standardStyle,
  });

  TextStyle standardStyle;

  /// every character of the textfield has a single entry,
  /// storing it's formatting settings
  Map<int, CharTile> charTiles = {};
  String _previousText = '';
  TextSelection _previousSelection =
      const TextSelection(baseOffset: 0, extentOffset: 0);

  bool _previousBold = false;
  bool _previousItalic = false;
  bool _previousUnderlined = false;
  bool _previousCode = false;
  Color _previousTextColor = Colors.white;
  //  @override
  // set text(String newText) {
  //   value = value.copyWith(
  //     text: newText,
  //     composing: TextRange.empty,
  //   );
  //   // notifyListeners();
  // }

  // @override
  // set value(TextEditingValue newValue) {
  //   final String newText = String.fromCharCodes(newValue.text.codeUnits);
  //   if (text != newText) {
  //     super.value = newValue.copyWith(
  //       text: newText,
  //       composing: TextRange.empty,
  //     );
  //     // notifyListeners();
  //   }
  // }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
    bool onlyUpdateCharTiles = false,
  }) {
    super.buildTextSpan(context: context, withComposing: withComposing);
    // text = String.fromCharCodes(text.codeUnits);
    // Runes runes = text.runes;
    // text = String.fromCharCodes(runes);
    // Runes runes16 = text.runes;
    // text = utf8.encode(text);
    final children = <InlineSpan>[];
    if (onlyUpdateCharTiles) {
      text = '';
      charTiles.forEach((key, value) {
        children.add(TextSpan(text: value.char, style: value.style));
        text += value.char;
      });
      _previousText = text;

      return TextSpan(style: style, children: children);
    }

    final isBold = context.read<TextEditorBloc>().isBold;
    final isItalic = context.read<TextEditorBloc>().isItalic;
    final isUnderlined = context.read<TextEditorBloc>().isUnderlined;
    final isCode = context.read<TextEditorBloc>().isCode;
    final textColor = KeyboardRow.returnColorFromTextColor(
      context.read<TextEditorBloc>().textColor,
    );

    final textDelta = text.characters.length - _previousText.characters.length;
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
          char: text.characters.elementAt(i),
          style: !isCode
              ? standardStyle.copyWith(
                  color: textColorToChange ?? charTiles[i]!.style.color,
                  fontWeight: boldToChange != null
                      ? boldToChange
                          ? FontWeight.bold
                          : standardStyle.fontWeight
                      : charTiles[i]!.style.fontWeight,
                  fontStyle: italicToChange != null
                      ? italicToChange
                          ? FontStyle.italic
                          : standardStyle.fontStyle
                      : charTiles[i]!.style.fontStyle,
                  decoration: underlinedToChange != null
                      ? underlinedToChange
                          ? TextDecoration.underline
                          : standardStyle.decoration
                      : charTiles[i]!.style.decoration,
                  background: standardStyle.background,
                )
              : standardStyle.copyWith(
                  color: Colors.white,
                  background: Paint()..color = Colors.black,
                ),
        );
      }
    } else {
      for (var i = 0; i < text.characters.length; i++) {
        if (i < selection.end) {
          if (text.characters.elementAt(i) == charTiles[i]?.char) {
            newCharTiles[i] = charTiles[i]!;
          } else {
            newCharTiles[i] = CharTile(
              char: text.characters.elementAt(i),
              style: !isCode
                  ? standardStyle.copyWith(
                      color: textColor,
                      fontWeight:
                          isBold ? FontWeight.bold : standardStyle.fontWeight,
                      fontStyle:
                          isItalic ? FontStyle.italic : standardStyle.fontStyle,
                      decoration: isUnderlined
                          ? TextDecoration.underline
                          : standardStyle.decoration,
                      background: standardStyle.background,
                    )
                  : standardStyle.copyWith(
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

  void addText(List<CharTile> newCharTiles, BuildContext context,
      {bool clearCharTiles = false}) {
    if (clearCharTiles) charTiles.clear();
    final charTilesStartLength = charTiles.length;
    for (var i = 0; i < newCharTiles.length; i++) {
      charTiles[i + charTilesStartLength] = newCharTiles[i];
    }
    buildTextSpan(
      context: context,
      withComposing: true,
      onlyUpdateCharTiles: true,
    );
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
