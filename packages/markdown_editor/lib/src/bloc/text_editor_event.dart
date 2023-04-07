// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'text_editor_bloc.dart';

@immutable
abstract class TextEditorEvent {}

class TextEditorKeyboardRowChange extends TextEditorEvent {
  bool? isBold;
  bool? isItalic;
  bool? isUnderlined;
  bool? isCode;
  TextColor? textColor;
  TextEditorKeyboardRowChange({
    this.isBold,
    this.isItalic,
    this.isUnderlined,
    this.isCode,
    this.textColor,
  });
}

class TextEditorAddEditorTile extends TextEditorEvent {
  EditorTile newEditorTile;
  EditorTile? senderEditorTile;
  TextEditorAddEditorTile({
    required this.newEditorTile,
    this.senderEditorTile,
  });
}

class TextEditorRemoveEditorTile extends TextEditorEvent {
  EditorTile tileToRemove;
  TextEditorRemoveEditorTile({
    required this.tileToRemove,
  });
}
