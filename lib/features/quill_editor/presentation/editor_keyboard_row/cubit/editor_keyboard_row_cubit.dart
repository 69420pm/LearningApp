import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

part 'editor_keyboard_row_state.dart';

class EditorKeyboardRowCubit extends Cubit<EditorKeyboardRowState> {
  EditorKeyboardRowCubit({required this.controller})
      : super(EditorKeyboardRowNothingSelected());
  QuillController controller;
  void selectFormatChars() {
    emit(EditorKeyboardRowFormatChars());
  }

  void selectCamera() {
    emit(EditorKeyboardRowImage());
  }

  void selectChangeTextColors() {
    emit(EditorKeyboardRowChangeTextColors());
  }

  void selectFormatLine() {
    emit(EditorKeyboardRowFormatLine());
  }

  void selectNothing() {
    emit(EditorKeyboardRowNothingSelected());
  }

  void changeTextColor(Color color) {
    controller.formatSelection(
      ColorAttribute('#' + color.value.toRadixString(16).toUpperCase()),
    );
    emit(EditorKeyboardRowFormatChars());
  }
}
