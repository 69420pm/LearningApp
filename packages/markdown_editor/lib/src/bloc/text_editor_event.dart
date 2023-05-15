// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'text_editor_bloc.dart';

abstract class TextEditorEvent {}

class TextEditorKeyboardRowChange extends TextEditorEvent {
  bool? isBold;
  bool? isItalic;
  bool? isUnderlined;
  bool? isCode;
  bool? isDefaultOnBackgroundTextColor;
  Color? textColor;
  Color? textBackgroundColor;
  TextEditorKeyboardRowChange({
    this.isBold,
    this.isItalic,
    this.isUnderlined,
    this.isCode,
    this.isDefaultOnBackgroundTextColor,
    this.textColor,
    this.textBackgroundColor,
  });
}

class TextEditorAddEditorTile extends TextEditorEvent {
  EditorTile newEditorTile;
  BuildContext context;
  TextEditorAddEditorTile({
    required this.newEditorTile,
    required this.context,
  });
}

class TextEditorRemoveEditorTile extends TextEditorEvent {
  EditorTile tileToRemove;
  BuildContext context;

  /// if tile gets deleted and text is still in textfield
  /// text gets passed to closest textfield above the deleted one
  bool handOverText;
  TextEditorRemoveEditorTile({
    required this.tileToRemove,
    required this.context,
    this.handOverText = false,
  });
}

class TextEditorReplaceEditorTile extends TextEditorEvent {
  EditorTile tileToRemove;
  EditorTile newEditorTile;
  BuildContext context;

  /// if tile gets deleted and text is still in textfield
  /// text gets passed to closest textfield above the deleted one
  bool handOverText;

  /// whether the replaced tile get focused
  bool requestFocus;

  TextEditorReplaceEditorTile({
    required this.tileToRemove,
    required this.newEditorTile,
    required this.context,
    this.handOverText = false,
    this.requestFocus = true,
  });
}
