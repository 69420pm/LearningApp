// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/models/char_tile.dart';

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
  bool _previousDefaultColor = true;
  Color _previousTextColor = Colors.white;
  Color _previousTextBackgroundColor = Colors.transparent;
  int _previousSelectionStart = 0;

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
      selection = _previousSelection;
      return TextSpan(style: style, children: children);
    }

    final isBold = context.read<TextEditorBloc>().isBold;
    final isItalic = context.read<TextEditorBloc>().isItalic;
    final isUnderlined = context.read<TextEditorBloc>().isUnderlined;
    final isCode = context.read<TextEditorBloc>().isCode;
    final isDefaultColor =
        context.read<TextEditorBloc>().isDefaultOnBackgroundTextColor;
    final textColor = context.read<TextEditorBloc>().textColor;
    final textBackgroundColor =
        context.read<TextEditorBloc>().textBackgroundColor;

    final textDelta = text.characters.length - _previousText.characters.length;
    final newCharTiles = <int, CharTile>{};

    var shiftSelectionEnd = 0;
    var shiftSelectionStart = 0;
    final previousSelectionStart = _previousSelectionStart;
    for (var i = 0; i < text.characters.length; i++) {
      if (text.characters.elementAt(i) != text[i + shiftSelectionEnd] &&
          i < selection.end - shiftSelectionEnd) {
        shiftSelectionEnd += 1;
      }
      if (text.characters.elementAt(i) != text[i + shiftSelectionStart] &&
          i < selection.start - shiftSelectionStart) {
        shiftSelectionStart += 1;
      }
      //! null reference exception problems get created here
      if (i + 1 == selection.start - shiftSelectionEnd) {
        _previousSelectionStart = i + 1;
      }
      // if (i == selection.start - shiftSelectionEnd) {
      //   _previousSelectionStart = i;
      // }
    }

    // change selection style
    if (text == _previousText &&
        (selection.end - selection.start) > 0 &&
        selection == _previousSelection) {
      bool? boldToChange;
      bool? italicToChange;
      bool? underlinedToChange;
      bool? codeToChange;
      bool? defaultColorChange;
      Color? textColorToChange;
      Color? textBackgroundColorToChange;
      if (isBold != _previousBold) {
        boldToChange = isBold;
      }
      if (isItalic != _previousItalic) {
        italicToChange = isItalic;
      }
      if (isUnderlined != _previousUnderlined) {
        underlinedToChange = isUnderlined;
      }
      if (isDefaultColor != _previousDefaultColor) {
        defaultColorChange = isDefaultColor;
      }
      if (textColor != _previousTextColor) {
        textColorToChange = textColor;
      }
      if (codeToChange != _previousCode) {
        codeToChange = isCode;
      }
      if (textBackgroundColor != _previousTextBackgroundColor) {
        textBackgroundColorToChange = textBackgroundColor;
      }
      for (var i = selection.start - shiftSelectionStart;
          i < selection.end - shiftSelectionEnd;
          i++) {
        charTiles[i] = CharTile(
          char: text.characters.elementAt(i),
          isDefaultOnBackgroundTextColor: isDefaultColor,
          isBold: isBold,
          isItalic: isItalic,
          isUnderlined: isUnderlined,
          style: !isCode
              ? standardStyle.copyWith(
                  color: defaultColorChange ?? false
                      ? Theme.of(context).colorScheme.onBackground
                      : textColorToChange ?? charTiles[i]!.style.color,
                  backgroundColor: textBackgroundColorToChange ??
                      charTiles[i]!.style.backgroundColor,
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
                  // TODO colors not theme specific
                  color: Theme.of(context).colorScheme.onBackground,
                  background: Paint()..color = Colors.transparent,
                ),
        );
      }
    } else if (text != _previousText) {
      for (var i = 0; i < text.characters.length; i++) {
        if (i < (selection.end - shiftSelectionEnd) &&
            i >= previousSelectionStart) {
          // if (text.characters.elementAt(i) == charTiles[i]?.char) {
          //   newCharTiles[i] = charTiles[i]!;
          // } else {
          newCharTiles[i] = CharTile(
            char: text.characters.elementAt(i),
            style: !isCode
                ? standardStyle.copyWith(
                    color: textColor,
                    backgroundColor: textBackgroundColor,
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
                    color: Theme.of(context).colorScheme.onBackground,
                    background: Paint()..color = Colors.transparent,
                  ),
            isDefaultOnBackgroundTextColor: isDefaultColor,
            isBold: isBold,
            isItalic: isItalic,
            isUnderlined: isUnderlined,
          );
          // }
        } else if (i < selection.end - shiftSelectionEnd) {
          newCharTiles[i] = charTiles[i]!;
        } else {
          newCharTiles[i] = charTiles[i - textDelta]!;
        }
      }
      charTiles = newCharTiles;
    }

    charTiles.forEach((key, value) {
      children.add(
        TextSpan(
          text: value.char,
          style: value.isDefaultOnBackgroundTextColor
              ? (value.style
                  .copyWith(color: Theme.of(context).colorScheme.onBackground))
              : value.style,
        ),
      );
    });
    _previousText = text;
    _previousSelection = selection;
    _previousBold = isBold;
    _previousItalic = isItalic;
    _previousUnderlined = isUnderlined;
    _previousCode = isCode;
    _previousDefaultColor = isDefaultColor;
    _previousTextColor = textColor;
    _previousTextBackgroundColor = textBackgroundColor;

    return TextSpan(style: style, children: children);
  }

  void addText(
    List<CharTile> newCharTiles,
    BuildContext context, {
    bool clearCharTiles = false,
  }) {
    if (clearCharTiles) charTiles.clear();
    final charTilesStartLength = charTiles.length;
    for (var i = 0; i < newCharTiles.length; i++) {
      final currentCharTile = newCharTiles[i];
      charTiles[i + charTilesStartLength] = currentCharTile.copyWith(
        /* style: newCharTiles[i].style.copyWith(
              fontFamily: standardStyle.fontFamily,
              fontSize: standardStyle.fontSize,
              fontWeight: newCharTiles[i].isBold
                  ? FontWeight.bold
                  : standardStyle.fontWeight,
              height: standardStyle.height,
            ), */
        style: standardStyle.copyWith(
          fontWeight: currentCharTile.isBold
              ? FontWeight.bold
              : standardStyle.fontWeight,
          fontStyle: currentCharTile.isItalic ? FontStyle.italic : null,
          decoration:
              currentCharTile.isUnderlined ? TextDecoration.underline : null,
          color: currentCharTile.isDefaultOnBackgroundTextColor
              ? Theme.of(context).colorScheme.onBackground
              : currentCharTile.style.color,
          backgroundColor: currentCharTile.style.backgroundColor,
        ),
      );
    }
    buildTextSpan(
      context: context,
      withComposing: true,
      onlyUpdateCharTiles: true,
    );
  }
}
