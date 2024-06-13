import 'package:flutter/material.dart';
import 'package:learning_app/features/editor/domain/entities/text_editor_style.dart';

class EditorTextStyleToTextStyle {
  static TextStyle editorTextStyleToTextStyle(TextEditorStyle editorTextStyle) {
    return TextStyle(
      fontStyle: editorTextStyle.isItalic == true
          ? FontStyle.italic
          : FontStyle.normal,
      fontWeight:
          editorTextStyle.isBold == true ? FontWeight.bold : FontWeight.normal,
      decoration: editorTextStyle.isUnderlined == true
          ? TextDecoration.underline
          : TextDecoration.none,
      decorationStyle: editorTextStyle.isStrikethrough == true
          ? TextDecorationStyle.double
          : TextDecorationStyle.solid,
      color: editorColorToColor(editorTextStyle.color),
      backgroundColor: editorColorToColor(editorTextStyle.backgroundColor),
    );
  }

  static TextEditorStyle textStyleToEditorTextStyle(TextStyle textStyle) {
    return TextEditorStyle(
      isItalic: textStyle.fontStyle == FontStyle.italic,
      isBold: textStyle.fontWeight == FontWeight.bold,
      isUnderlined: textStyle.decoration == TextDecoration.underline,
      isStrikethrough: textStyle.decorationStyle == TextDecorationStyle.double,
      color: colorToEditorColor(textStyle.color ?? Colors.white),
      backgroundColor:
          colorToEditorColor(textStyle.backgroundColor ?? Colors.transparent),
      paragraphStyle: ParagraphStyle.body,
    );
  }

  static Color editorColorToColor(EditorColor editorColor) {
    switch (editorColor) {
      case EditorColor.red:
        return Colors.red;
      case EditorColor.blue:
        return Colors.blue;
      case EditorColor.green:
        return Colors.green;
      case EditorColor.yellow:
        return Colors.yellow;
      case EditorColor.orange:
        return Colors.orange;
      case EditorColor.purple:
        return Colors.purple;
      case EditorColor.brown:
        return Colors.brown;
      case EditorColor.black:
        return Colors.black;
      case EditorColor.white:
        return Colors.white;
      case EditorColor.gray:
        return Colors.grey;
      case EditorColor.transparent:
        return Colors.transparent;
      default:
        return Colors.white;
    }
  }

  static EditorColor colorToEditorColor(Color color) {
    if (color == Colors.red) return EditorColor.red;
    if (color == Colors.blue) return EditorColor.blue;
    if (color == Colors.green) return EditorColor.green;
    if (color == Colors.yellow) return EditorColor.yellow;
    if (color == Colors.orange) return EditorColor.orange;
    if (color == Colors.purple) return EditorColor.purple;
    if (color == Colors.brown) return EditorColor.brown;
    if (color == Colors.black) return EditorColor.black;
    if (color == Colors.white) return EditorColor.white;
    if (color == Colors.grey) return EditorColor.gray;
    if (color == Colors.transparent) return EditorColor.transparent;
    return EditorColor.white;
  }
}
