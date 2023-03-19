import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'text_editor_event.dart';
part 'text_editor_state.dart';

/// bloc for handling all text editor relevant state management
class TextEditorBloc extends Bloc<TextEditorEvent, TextEditorState> {
  /// constructor
  TextEditorBloc(
      {this.isBold = false, this.isItalic = false, this.isUnderlined = false})
      : super(TextEditorInitial()) {
    on<TextEditorEvent>((event, emit) {});
    on<TextEditorKeyboardRowChange>(_keyboardRowChange);
  }

  /// whether text should get written in bold or not
  bool isBold;

  /// whether text should get written italic or not
  bool isItalic;

  /// whether text should get written underlined or not
  bool isUnderlined;

  FutureOr<void> _keyboardRowChange(
    TextEditorKeyboardRowChange event,
    Emitter<TextEditorState> emit,
  ) {
    isBold = event.isBold;
    isItalic = event.isItalic;
    isUnderlined = event.isUnderlined;
    emit(TextEditorKeyboardRowChanged());
  }
}
