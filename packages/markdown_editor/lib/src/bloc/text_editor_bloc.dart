import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/list_editor_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';
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
      this.textColor = TextColor.white,
      this.textBackgroundColor = TextBackgroundColor.noBG})
      : super(TextEditorInitial()) {
    on<TextEditorKeyboardRowChange>(_keyboardRowChange);
    on<TextEditorAddEditorTile>(_addTile);
    on<TextEditorRemoveEditorTile>(_removeTile);
    on<TextEditorReplaceEditorTile>(_replaceTile);
  }

  /// list of all editorTiles (textWidgets, Images, etc.) of text editor
  List<EditorTile> editorTiles = [
    TextTile(
      textStyle: TextFieldConstants.normal,
    )
  ];

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

  /// background color of text as enum
  TextBackgroundColor textBackgroundColor;

  EditorTile? focusedTile;

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
    textBackgroundColor = event.textBackgroundColor != null
        ? event.textBackgroundColor!
        : textBackgroundColor;
    emit(TextEditorKeyboardRowChanged());
  }

  FutureOr<void> _addTile(
    TextEditorAddEditorTile event,
    Emitter<TextEditorState> emit,
  ) {
    _addEditorTile(event.newEditorTile, event.context);
    emit(TextEditorEditorTilesChanged(tiles: List.of(editorTiles)));
  }

  FutureOr<void> _removeTile(
    TextEditorRemoveEditorTile event,
    Emitter<TextEditorState> emit,
  ) {
    _removeEditorTile(event.tileToRemove, event.context, handOverText: true);
    emit(TextEditorEditorTilesChanged(tiles: List.of(editorTiles)));
  }

  FutureOr<void> _replaceTile(
    TextEditorReplaceEditorTile event,
    Emitter<TextEditorState> emit,
  ) {
    for (var i = 0; i < editorTiles.length; i++) {
      if (editorTiles[i] == event.tileToRemove) {
        editorTiles[i] = event.newEditorTile;
        focusedTile = editorTiles[i];
        if (editorTiles[i].focusNode != null && event.requestFocus) {
          editorTiles[i].focusNode?.requestFocus();
        }
        break;
      }
    }
    updateOrderedListTile();

    var list1 = <EditorTile>[
      TextTile(
        textStyle: TextFieldConstants.calloutStart,
      ),
      TextTile(
        textStyle: TextFieldConstants.calloutStart,
      )
    ];
    var list2 = list1;
    list2[0].textFieldController!.text = "fd";
    // List<EditorTile> list2 = [TextTile(textStyle: TextFieldConstants.calloutStart,), TextTile(textStyle: TextFieldConstants.calloutStart,)];
    print(list1 == list2);
    print(list1[0].textFieldController!.text ==
        list2[0].textFieldController!.text);
    emit(TextEditorEditorTilesChanged(tiles: List.of(editorTiles)));
  }

  void _addEditorTile(EditorTile toAdd, BuildContext context) {
    for (var i = 0; i < editorTiles.length; i++) {
      // get focused/current editorTile,
      // or the last one when no tile is focused
      if (editorTiles[i] == focusedTile ||
          (editorTiles[i].focusNode != null &&
              editorTiles[i].focusNode!.hasFocus) ||
          i == editorTiles.length - 1) {
        // if focused textfield is an empty TextTile
        if (editorTiles[i].focusNode != null &&
            editorTiles[i].focusNode!.hasFocus &&
            editorTiles[i] is TextTile &&
            (editorTiles[i] as TextTile).textFieldController!.text.isEmpty) {
          // replace empty TextTile
          editorTiles[i] = toAdd;
          focusedTile = editorTiles[i];
          editorTiles[i].focusNode?.requestFocus();
          return;
        }

        // all editorTiles behind focused tile
        final sublist = editorTiles.sublist(i + 1);
        editorTiles.removeRange(i + 1, editorTiles.length);
        _shiftTextAddEditorTile(toAdd, editorTiles[i], context);
        for (var j = 0; j < sublist.length; j++) {
          editorTiles.add(sublist[j]);
        }

        /*if (editorTiles.length - 1 < (i + 1)) {
          _shiftTextAddEditorTile(toAdd, editorTiles[i], context);
        } else {
          editorTiles[i + 1] = toAdd;
          // _shiftTextAddEditorTile(toAdd, ed, context)
        }

        editorTiles.removeRange(i + 1, editorTiles.length);
        // toAdd.focusNode?.requestFocus();
        for (var j = 0; j < sublist.length; j++) {
          if (editorTiles.length - 1 > (i + j + 2)) {
            editorTiles[i + j + 2] = sublist[j];
          } else {
            _shiftTextAddEditorTile(sublist[j], editorTiles[i], context);
            // editorTiles.add(sublist[j]);
          }
        }*/
        editorTiles = editorTiles.whereType<EditorTile>().toList();
        break;
      }
    }
    updateOrderedListTile();
  }

  void _shiftTextAddEditorTile(
    EditorTile newTile,
    EditorTile current,
    BuildContext context, {
    int? indexOfEditorTilesToAddNewTile,
  }) {
    if (newTile.textFieldController != null &&
        current.textFieldController != null) {
      final selectionEnd = current.textFieldController?.selection.end;
      final oldFieldTiles = <CharTile>[];
      final newFieldTiles = <CharTile>[];
      current.textFieldController?.charTiles.forEach((key, value) {
        if (key >= selectionEnd!) {
          newFieldTiles.add(value);
        } else {
          oldFieldTiles.add(value);
        }
      });
      current.textFieldController!
          .addText(oldFieldTiles, context, clearCharTiles: true);
      newTile.focusNode?.requestFocus();
      newTile.textFieldController!.addText(newFieldTiles, context);
    }
    if (indexOfEditorTilesToAddNewTile == null) {
      editorTiles.add(newTile);
    } else {
      editorTiles[indexOfEditorTilesToAddNewTile] = newTile;
    }
    newTile.focusNode?.requestFocus();
  }

  void _removeEditorTile(
    EditorTile toRemove,
    BuildContext context, {
    bool changeFocus = true,
    bool handOverText = false,
  }) {
    var highestFocusNodeTile = -1;
    for (var i = 0; i < editorTiles.length; i++) {
      if (editorTiles[i] == toRemove) {
        editorTiles.remove(editorTiles[i]);
        for (var j = i - 1; j >= 0; j--) {
          if (editorTiles[j].focusNode != null) {
            if (handOverText == false) {
              editorTiles[j].focusNode?.requestFocus();
              focusedTile = editorTiles[i];
              break;
            }
            highestFocusNodeTile = i;
            if (editorTiles[j].textFieldController != null &&
                toRemove.textFieldController != null) {
              final newCharTiles = <CharTile>[];
              toRemove.textFieldController!.charTiles.forEach((key, value) {
                newCharTiles.add(value);
              });

              editorTiles[j]
                  .textFieldController!
                  .addText(newCharTiles, context);

              if (changeFocus) {
                editorTiles[j].focusNode?.requestFocus();
              }
              break;
            }
            if (j == 0 && highestFocusNodeTile != -1) {
              if (changeFocus) {
                editorTiles[highestFocusNodeTile].focusNode?.requestFocus();
              }
              break;
            }
          }
        }
        break;
      }
    }
    if (editorTiles.isEmpty) {
      editorTiles.add(
        TextTile(
          textStyle: TextFieldConstants.normal,
        ),
      );
      editorTiles[0].focusNode?.requestFocus();
    }
    updateOrderedListTile();
  }

  void updateOrderedListTile() {
    for (var i = 0; i < editorTiles.length; i++) {
      if (editorTiles[i] is ListEditorTile &&
          (editorTiles[i] as ListEditorTile).orderNumber != 0) {
        if (i != 0 &&
            editorTiles[i - 1] is ListEditorTile &&
            (editorTiles[i - 1] as ListEditorTile).orderNumber != 0) {
          final eTi = editorTiles[i] as ListEditorTile;
          final eTi1 = editorTiles[i - 1] as ListEditorTile;
          var focusTile = false;

          if (editorTiles[i - 1] == focusedTile) {
            focusTile = true;
          }
          // if ((editorTiles[i] as ListEditorTile).orderNumber ==
          //     eTi1.orderNumber + 1) {
          //   break;
          // }
          if (editorTiles[i].focusNode!.hasFocus) {
            editorTiles[i] = eTi.copyWith(orderNumber: eTi1.orderNumber + 1);
            // editorTiles[i].focusNode?.requestFocus();
          } else {
            editorTiles[i] = eTi.copyWith(orderNumber: eTi1.orderNumber + 1);
          }
          if (focusTile) {
            // editorTiles[i].focusNode?.requestFocus();
          }
        } else {
          var focusTile = false;
          if (editorTiles[i] == focusedTile) {
            focusTile = true;
          }
          // if ((editorTiles[i] as ListEditorTile).orderNumber == 1) {
          //   break;
          // }
          editorTiles[i] =
              (editorTiles[i] as ListEditorTile).copyWith(orderNumber: 1);

          if (editorTiles[i].focusNode!.hasFocus) {
            editorTiles[i] =
                (editorTiles[i] as ListEditorTile).copyWith(orderNumber: 1);
            // editorTiles[i].focusNode?.requestFocus();
          } else {
            editorTiles[i] =
                (editorTiles[i] as ListEditorTile).copyWith(orderNumber: 1);
          }
          if (focusTile) {
            // editorTiles[i].focusNode?.requestFocus();
          }
        }
      }
    }
  }
}
