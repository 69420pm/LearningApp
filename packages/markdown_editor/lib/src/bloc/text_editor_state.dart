// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'text_editor_bloc.dart';

abstract class TextEditorState {}

class TextEditorInitial extends TextEditorState {}

class TextEditorKeyboardRowChanged extends TextEditorState {}

class TextEditorEditorTilesChanged extends TextEditorState {
  List<EditorTile> tiles;
  TextEditorEditorTilesChanged({
    required this.tiles,
  });
}

enum TextColor {
  white,
  white60,
  white38,
  brown,
  orange,
  yellow,
  green,
  blue,
  purple,
  pink,
  red,
}

enum TextBackgroundColor {
  noBG,
  white60BG,
  white38BG,
  brownBG,
  orangeBG,
  yellowBG,
  greenBG,
  blueBG,
  purpleBG,
  pinkBG,
  redBG
}
