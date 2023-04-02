import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_tile.dart';
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
    on<TextEditorKeyboardRowChange>(_keyboardRowChange);
    on<TextEditorAddEditorTile>(_addTile);
  }

  /// list of all editorTiles (textWidgets, Images, etc.) of text editor
  List<EditorTile> editorTiles = [TextTile()];

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
    isCode = event.isCode != null ? event.isCode! : isCode;
    textColor = event.textColor != null ? event.textColor! : textColor;
    emit(TextEditorKeyboardRowChanged());
  }

  FutureOr<void> _addTile(
      TextEditorAddEditorTile event, Emitter<TextEditorState> emit) {
    if (event.senderEditorTile != null) {
      for (var i = 0; i < editorTiles.length; i++) {
        if (editorTiles[i] == event.senderEditorTile) {
          final sublist = editorTiles.sublist(i + 1);
          if (editorTiles.length - 1 < (i + 1)) {
            editorTiles.add(event.newEditorTile);
          } else {
            editorTiles[i + 1] = event.newEditorTile;
          }
          for (var j = 0; j < sublist.length; j++) {
            if (editorTiles.length - 1 > (i + j + 2)) {
              editorTiles[i + j + 2] = sublist[j];
            } else {
              editorTiles.add(sublist[j]);
            }
          }
          break;
        }
      }
    } else {
      editorTiles.add(event.newEditorTile);
    }

    emit(TextEditorEditorTilesChanged(tiles: editorTiles));
  }
}
