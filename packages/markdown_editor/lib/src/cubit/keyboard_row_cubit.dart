import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:ui_components/ui_components.dart';

part 'keyboard_row_state.dart';

class KeyboardRowCubit extends Cubit<KeyboardRowState> {
  KeyboardRowCubit(this.textEditorBloc)
      : super(KeyboardRowText(
          isBold: textEditorBloc.isBold,
          isItalic: textEditorBloc.isItalic,
          isUnderlined: textEditorBloc.isUnderlined,
          textColor: textEditorBloc.textColor,
          backgroundColor: textEditorBloc.textBackgroundColor,
        ),);

  TextEditorBloc textEditorBloc;
  bool expandedTextColors = false;
  bool expandedBackgroundColors = false;

  // bool _textColors = false;
  // bool _extraFormat = false;

  // void expandTextColors() {
  //   _extraFormat = false;
  //   _textColors = !_textColors;
  //   _textColors ? emit(KeyboardRowTextColors()) : emit(KeyboardRowFavorites());
  // }

  // void expandExtraFormat() {
  //   _textColors = false;
  //   _extraFormat = !_extraFormat;
  //   _extraFormat
  //       ? emit(KeyboardRowExtraFormat())
  //       : emit(KeyboardRowFavorites());
  // }

  void updateTextRow() {
    emit(KeyboardRowText(
      isBold: textEditorBloc.isBold,
      isItalic: textEditorBloc.isItalic,
      isUnderlined: textEditorBloc.isUnderlined,
      textColor: textEditorBloc.textColor,
      backgroundColor: textEditorBloc.textBackgroundColor,
    ),);
  }

  void expandText() {
    emit(KeyboardRowText(
      isBold: textEditorBloc.isBold,
      isItalic: textEditorBloc.isItalic,
      isUnderlined: textEditorBloc.isUnderlined,
      textColor: textEditorBloc.textColor,
      backgroundColor: textEditorBloc.textBackgroundColor,
    ),);
    expandedTextColors = false;
    expandedBackgroundColors = false;
  }

  void expandTextColors() {
    expandedTextColors = true;
    expandedBackgroundColors = false;
    emit(KeyboardRowTextColors());
  }

  void expandBackgroundColors() {
    expandedBackgroundColors = true;
    expandedTextColors = false;
    emit(KeyboardRowBackgroundColors());
  }

  void expandAddNewTile() {
    emit(KeyboardRowNewTile());
    expandedTextColors = false;
    expandedBackgroundColors = false;
  }

  void changeTextColor(Color color, TextEditorBloc textEditorBloc) {
    textEditorBloc.add(TextEditorKeyboardRowChange(textColor: color));
    expandedTextColors = false;
    expandedBackgroundColors = false;
    emit(
      KeyboardRowText(
        isBold: textEditorBloc.isBold,
        isItalic: textEditorBloc.isItalic,
        isUnderlined: textEditorBloc.isUnderlined,
        textColor: textEditorBloc.textColor,
        backgroundColor: textEditorBloc.textBackgroundColor,
      ),
    );
  }

  void defaultTextColor(TextEditorBloc textEditorBloc) {
    emit(
      KeyboardRowText(
        isBold: textEditorBloc.isBold,
        isItalic: textEditorBloc.isItalic,
        isUnderlined: textEditorBloc.isUnderlined,
        backgroundColor: textEditorBloc.textBackgroundColor,
        textColor: UIColors.textLight,
      ),
    );
  }

  void changeBackgroundColor(Color color, TextEditorBloc textEditorBloc) {
    textEditorBloc.add(TextEditorKeyboardRowChange(textBackgroundColor: color));
    expandedTextColors = false;
    expandedBackgroundColors = false;
    emit(
      KeyboardRowText(
        isBold: textEditorBloc.isBold,
        isItalic: textEditorBloc.isItalic,
        isUnderlined: textEditorBloc.isUnderlined,
        textColor: textEditorBloc.textColor,
        backgroundColor: color,
      ),
    );
  }

  void addNewTile(
    EditorTile tile,
    TextEditorBloc textEditorBloc,
    BuildContext context, {
    bool emitState = true,
  }) {
    textEditorBloc.add(
      TextEditorAddEditorTile(
        newEditorTile: tile,
        context: context,
        emitState: emitState,
      ),
    );
    expandText();
  }

  void saveCard() {}

  // void expandAddNewTextTile() {
  //   _textColors = false;
  //   _extraFormat = false;
  //   emit(KeyboardRowNewTextTile());
  // }
}
