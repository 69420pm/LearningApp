// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/models/char_tile.dart';
import 'package:ui_components/ui_components.dart';

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
  Color _previousTextColor = Colors.white;
  Color _previousTextBackgroundColor = Colors.transparent;
  List<HyperLinkEntry> hyperLinks = [];
  int shiftSelectionStart = 0;
  int shiftSelectionEnd = 0;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
    bool onlyUpdateCharTiles = false,
  }) {
    super.buildTextSpan(context: context, withComposing: withComposing);
    final children = <InlineSpan>[];
    // // optimize
    // if (onlyUpdateCharTiles) {
    //   text = '';
    //   charTiles.forEach((key, value) {
    //     children.add(TextSpan(text: value.text, style: value.style));
    //     text += value.text;
    //   });
    //   _previousText = text;
    //   selection = _previousSelection;
    //   return TextSpan(style: style, children: children);
    // }
    // final isBold = context.read<TextEditorBloc>().isBold;
    // final isItalic = context.read<TextEditorBloc>().isItalic;
    // final isUnderlined = context.read<TextEditorBloc>().isUnderlined;
    // final textColor = context.read<TextEditorBloc>().textColor;
    // final textBackgroundColor =
    //     context.read<TextEditorBloc>().textBackgroundColor;
    // final styleChanged = isBold == _previousBold &&
    //     isItalic == _previousItalic &&
    //     isUnderlined == _previousUnderlined &&
    //     textColor == _previousTextColor &&
    //     textBackgroundColor == _previousTextBackgroundColor;
    // final textDelta = text.characters.length - _previousText.characters.length;
    // // _selectionDelta(selection, _previousSelection);

    // var shiftSelectionEnd = 0;
    // var shiftSelectionStart = 0;
    // for (var i = 0; i < text.characters.length; i++) {
    //   if (text.characters.elementAt(i) != text[i + shiftSelectionEnd] &&
    //       i < selection.end - shiftSelectionEnd) {
    //     shiftSelectionEnd += 1;
    //   }
    //   if (text.characters.elementAt(i) != text[i + shiftSelectionStart] &&
    //       i < selection.start - shiftSelectionStart) {
    //     shiftSelectionStart += 1;
    //   }
    // }

    // if (styleChanged) {
    //   // new characters
    //   if (textDelta > 0) {
    //   }
    //   // characters got removed
    //   else if (textDelta < 0) {
    //   }
    //   // selection format changed
    //   else {}
    // } else {
    //   // new characters
    //   if (textDelta > 0) {
    //   }
    //   // characters got removed
    //   else if (textDelta < 0) {
    //   }
    //   // selection format changed
    //   else {}
    // }

    // ----------------------------------------

    hyperLinks = [];
    // final children = <InlineSpan>[];
    if (onlyUpdateCharTiles) {
      text = '';
      charTiles.forEach((key, value) {
        children.add(TextSpan(text: value.text, style: value.style));
        text += value.text;
      });
      _previousText = text;
      selection = _previousSelection;
      return TextSpan(style: style, children: children);
    }

    final isBold = context.read<TextEditorBloc>().isBold;
    final isItalic = context.read<TextEditorBloc>().isItalic;
    final isUnderlined = context.read<TextEditorBloc>().isUnderlined;
    final textColor = context.read<TextEditorBloc>().textColor;
    final textBackgroundColor =
        context.read<TextEditorBloc>().textBackgroundColor;

    final textDelta = text.characters.length - _previousText.characters.length;
    final newCharTiles = <int, CharTile>{};

    var shiftSelectionEnd = 0;
    var shiftSelectionStart = 0;
    // emojis are in text
    if (text.characters.length != text.length) {
      for (var i = 0; i < text.characters.length; i++) {
        if (text.characters.elementAt(i) != text[i + shiftSelectionEnd] &&
            i < selection.end - shiftSelectionEnd) {
          shiftSelectionEnd += 1;
        }
        if (text.characters.elementAt(i) != text[i + shiftSelectionStart] &&
            i < selection.start - shiftSelectionStart) {
          shiftSelectionStart += 1;
        }
      }
    }

    // change selection style
    if (text == _previousText &&
        (selection.end - selection.start) > 0 &&
        selection == _previousSelection) {
      bool? boldToChange;
      bool? italicToChange;
      bool? underlinedToChange;
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

      if (textColor != _previousTextColor) {
        textColorToChange = textColor;
      }

      if (textBackgroundColor != _previousTextBackgroundColor) {
        textBackgroundColorToChange = textBackgroundColor;
      }
      for (var i = selection.start - shiftSelectionStart;
          i < selection.end - shiftSelectionEnd;
          i++) {
        charTiles[i] = CharTile(
          text: text.characters.elementAt(i),
          isBold: isBold,
          isItalic: isItalic,
          isUnderlined: isUnderlined,
          style: standardStyle.copyWith(
            color: textColorToChange ?? charTiles[i]!.style.color,
            decorationColor: textColorToChange ?? charTiles[i]!.style.color,
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
            // decorationColor: underlinedToChange != null ? underlinedToChange?charTiles[i].,
            background: standardStyle.background,
          ),
        );
      }
      // if text has changed
    } else if (text != _previousText) {
      for (var i = 0; i < text.characters.length; i++) {
        // add new chars
        //! was previously _previousSelectionStart
        //! instead of _previousSelection.start
        if (i < (selection.end - shiftSelectionEnd) &&
            i >= _previousSelection.start - shiftSelectionStart) {
          // if (text.characters.elementAt(i) == charTiles[i]?.char) {
          //   newCharTiles[i] = charTiles[i]!;
          // } else {
          newCharTiles[i] = CharTile(
            text: text.characters.elementAt(i),
            style: standardStyle.copyWith(
              color: textColor,
              decorationColor: textColor,
              backgroundColor: textBackgroundColor,
              fontWeight: isBold ? FontWeight.bold : standardStyle.fontWeight,
              fontStyle: isItalic ? FontStyle.italic : standardStyle.fontStyle,
              decoration: isUnderlined
                  ? TextDecoration.underline
                  : standardStyle.decoration,
              background: standardStyle.background,
            ),
            isBold: isBold,
            isItalic: isItalic,
            isUnderlined: isUnderlined,
          );
          // }
        }
        // add chars before selection
        else if (i < selection.end - shiftSelectionEnd) {
          //! error with emojis occurring
          newCharTiles[i] = charTiles[i]!;
        }
        // add chars after selection
        else {
          newCharTiles[i] = charTiles[i - textDelta]!;
        }
      }

      charTiles = newCharTiles;
    }
    // check for hyperlink
    final regex = RegExp(
      r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)',
    ); // Match one or more digits
    for (final Match match in regex.allMatches(text)) {
      hyperLinks.add(HyperLinkEntry(start: match.start, end: match.end - 1));
    }
    charTiles.forEach((key, value) {
      children.add(
        HyperLinkEntry.checkHyperLink(key, hyperLinks) != null
            ? TextSpan(
                text: value.text,
                style: value.style.copyWith(
                  color: UIColors.focused,
                  decoration: TextDecoration.underline,
                  decorationColor: UIColors.focused,
                ),
              )
            : TextSpan(
                text: value.text,
                style: value.style,
              ),
      );
    });
    _previousText = text;
    _previousSelection = selection;
    _previousBold = isBold;
    _previousItalic = isItalic;
    _previousUnderlined = isUnderlined;
    _previousTextColor = textColor;
    _previousTextBackgroundColor = textBackgroundColor;

    return TextSpan(style: style, children: children);
  }

  // List<int> _selectionDelta(TextSelection current, TextSelection previous){
  //   int startSelectionDelta = current.start - previous.start;
  //   int endSelectionDelta = current.end - previous.end;
  //   if(text[])
  //   return [1,2];
  // }

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
          color: currentCharTile.style.color,
          decorationColor: currentCharTile.style.color,
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

class HyperLinkEntry {
  int start;
  int end;
  HyperLinkEntry({
    required this.start,
    required this.end,
  });

  static HyperLinkEntry? checkHyperLink(
    int key,
    List<HyperLinkEntry> hyperLinks,
  ) {
    for (final element in hyperLinks) {
      if (key >= element.start && key <= element.end) {
        return element;
      }
    }
    return null;
  }
}
