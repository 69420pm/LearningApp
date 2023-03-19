part of 'text_editor_bloc.dart';

@immutable
abstract class TextEditorState {}

class TextEditorInitial extends TextEditorState {}

class TextEditorKeyboardRowChanged extends TextEditorState {}
