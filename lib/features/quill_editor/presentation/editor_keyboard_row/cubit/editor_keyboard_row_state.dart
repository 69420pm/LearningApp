part of 'editor_keyboard_row_cubit.dart';

sealed class EditorKeyboardRowState extends Equatable {
  const EditorKeyboardRowState();

  @override
  List<Object> get props => [];
}

final class EditorKeyboardRowNothingSelected extends EditorKeyboardRowState {}

final class EditorKeyboardRowImage extends EditorKeyboardRowState {}

final class EditorKeyboardRowFormatChars extends EditorKeyboardRowState {}

final class EditorKeyboardRowFormatLine extends EditorKeyboardRowState {}

final class EditorKeyboardRowChangeTextColors extends EditorKeyboardRowState {}
