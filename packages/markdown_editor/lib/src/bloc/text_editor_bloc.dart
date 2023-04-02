import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'text_editor_event.dart';
part 'text_editor_state.dart';

/// bloc for handling all text editor relevant state management
class TextEditorBloc extends Bloc<TextEditorEvent, TextEditorState> {
  /// constructor
  TextEditorBloc(
      {this.isBold = false,
      this.isItalic = false,
      this.isUnderlined = false,
      this.isCode = false,
      this.textColor = TextColor.white})
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

  /// whether text should get formatted as code
  bool isCode;

  /// color of text as enum
  TextColor textColor;

  FutureOr<void> _keyboardRowChange(
    TextEditorKeyboardRowChange event,
    Emitter<TextEditorState> emit,
  ) {
    isBold = event.isBold != null ? event.isBold! : isBold;
    isItalic = event.isItalic != null ? event.isItalic! : isItalic;
    isUnderlined =
        event.isUnderlined != null ? event.isUnderlined! : isUnderlined;
    isCode = event.isCode != null ?event.isCode!:isCode;
    textColor = event.textColor != null ? event.textColor! : textColor;
    emit(TextEditorKeyboardRowChanged());
  }
}
