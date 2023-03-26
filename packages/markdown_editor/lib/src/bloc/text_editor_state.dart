part of 'text_editor_bloc.dart';

@immutable
abstract class TextEditorState {}

class TextEditorInitial extends TextEditorState {}

class TextEditorKeyboardRowChanged extends TextEditorState {}

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
  red
}
