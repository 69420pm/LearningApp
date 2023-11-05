// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'text_editor_bloc.dart';

abstract class TextEditorEvent {}

class TextEditorKeyboardRowChange extends TextEditorEvent {
  bool? isBold;
  bool? isItalic;
  bool? isUnderlined;
  bool? isCode;
  Color? textColor;
  Color? textBackgroundColor;
  TextEditorKeyboardRowChange({
    this.isBold,
    this.isItalic,
    this.isUnderlined,
    this.isCode,
    this.textColor,
    this.textBackgroundColor,
  });
}

class TextEditorAddEditorTile extends TextEditorEvent {
  EditorTile newEditorTile;
  BuildContext context;
  bool emitState;
  TextEditorAddEditorTile(
      {required this.newEditorTile,
      required this.context,
      this.emitState = true});
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

class TextEditorChangeOrderOfTile extends TextEditorEvent {
  int oldIndex;
  int newIndex;
  TextEditorChangeOrderOfTile({
    required this.oldIndex,
    required this.newIndex,
  });
}

class TextEditorGetSavedEditorTiles extends TextEditorEvent {
  BuildContext context;
  TextEditorGetSavedEditorTiles({
    required this.context,
  });
}

class TextEditorFocusLastWidget extends TextEditorEvent {}

class TextEditorNextCard extends TextEditorEvent {
  BuildContext context;
  TextEditorNextCard({
    required this.context,
  });

}
