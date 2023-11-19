import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/list_editor_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';
import 'package:ui_components/ui_components.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:markdown_editor/src/models/char_tile.dart';
import 'package:learning_app/app/helper/uid.dart';
part 'text_editor_event.dart';
part 'text_editor_state.dart';

/// bloc for handling all text editor relevant state management
class TextEditorBloc extends Bloc<TextEditorEvent, TextEditorState> {
  /// constructor
  TextEditorBloc(
    this._saveEditorTilesCallback,
    this.editorTiles,
    this.parentId, {
    this.isBold = false,
    this.isItalic = false,
    this.isUnderlined = false,
    this.textColor = UIColors.textLight,
    this.textBackgroundColor = Colors.transparent,
  }) : super(TextEditorInitial()) {
    on<TextEditorKeyboardRowChange>(_keyboardRowChange);
    on<TextEditorAddEditorTile>(_addTile);
    on<TextEditorRemoveEditorTile>(_removeTile);
    on<TextEditorReplaceEditorTile>(_replaceTile);
    on<TextEditorChangeOrderOfTile>(_changeOrderOfTile);
    on<TextEditorFocusLastWidget>(_focusLastWidget);
    on<TextEditorNextCard>(_nextCard);
    on<TextEditorSetFocusedWidget>(_setFocusedWidget);
    on<TextEditorAddWidgetAboveSeparator>(_addWidgetAboveSeparator);
    on<TextEditorFocusWidgetAfterSeparator>(_focusWidgetAfterSeparator);
    // on<TextEditor
  }

  final String? parentId;

  /// list of all editorTiles (textWidgets, Images, etc.) of text editor
  List<EditorTile> editorTiles;

  final void Function(List<EditorTile>) _saveEditorTilesCallback;

  /// whether text should get written in bold or not
  bool isBold;

  /// whether text should get written italic or not
  bool isItalic;

  /// whether text should get written underlined or not
  bool isUnderlined;

  /// color of text
  Color textColor;

  /// background color of text
  Color textBackgroundColor;

  FocusNode? _focusedWidget;

  FutureOr<void> _keyboardRowChange(
    TextEditorKeyboardRowChange event,
    Emitter<TextEditorState> emit,
  ) {
    isBold = event.isBold != null ? event.isBold! : isBold;
    isItalic = event.isItalic != null ? event.isItalic! : isItalic;
    isUnderlined =
        event.isUnderlined != null ? event.isUnderlined! : isUnderlined;
    textColor = event.textColor != null ? event.textColor! : textColor;
    textBackgroundColor = event.textBackgroundColor != null
        ? event.textBackgroundColor!
        : textBackgroundColor;

    emit(
      TextEditorKeyboardRowChanged(
        isBold: isBold,
        isItalic: isItalic,
        isUnderlined: isUnderlined,
        textColor: textColor,
        textBackgroundColor: textBackgroundColor,
      ),
    );
  }

  FutureOr<void> _addTile(
    TextEditorAddEditorTile event,
    Emitter<TextEditorState> emit,
  ) {
    _addEditorTile(event.newEditorTile, event.context, null);
    if (event.newEditorTile.focusNode == null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    if (event.emitState) {
      emit(TextEditorEditorTilesChanged(tiles: List.of(editorTiles)));
    }
    _saveEditorTiles();
  }

  FutureOr<void> _removeTile(
    TextEditorRemoveEditorTile event,
    Emitter<TextEditorState> emit,
  ) {
    _removeEditorTile(
      event.tileToRemove,
      event.context,
      handOverText: event.handOverText,
    );
    emit(TextEditorEditorTilesChanged(tiles: List.of(editorTiles)));
    _saveEditorTiles();
  }

  FutureOr<void> _replaceTile(
    TextEditorReplaceEditorTile event,
    Emitter<TextEditorState> emit,
  ) {
    for (var i = 0; i < editorTiles.length; i++) {
      if (editorTiles[i] == event.tileToRemove) {
        editorTiles[i] = event.newEditorTile;
        if (editorTiles[i].focusNode != null && event.requestFocus) {
          editorTiles[i].focusNode?.requestFocus();
        }
        break;
      }
    }
    _updateOrderedListTile();

    emit(TextEditorEditorTilesChanged(tiles: List.of(editorTiles)));
    _saveEditorTiles();
  }

  void _addEditorTile(EditorTile toAdd, BuildContext context, int? indexToAdd) {
    for (var i = 0; i < editorTiles.length; i++) {
      // get focused/current editorTile,
      // or the last one when no tile is focused
      if (indexToAdd == i ||
          (_focusedWidget != null &&
              editorTiles[i].focusNode == _focusedWidget) ||
          (editorTiles[i].focusNode == FocusManager.instance.primaryFocus ||
              i == editorTiles.length - 1)) {
        if (_focusedWidget != null) {
          _focusedWidget = null;
        }
        // if focused textfield is an empty TextTile
        if (editorTiles[i].focusNode != null &&
            editorTiles[i].focusNode!.hasFocus &&
            editorTiles[i] is TextTile &&
            (editorTiles[i] as TextTile).textFieldController!.text.isEmpty &&
            toAdd is! TextTile) {
          // replace empty TextTile
          editorTiles[i] = toAdd;
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

        editorTiles = editorTiles.whereType<EditorTile>().toList();
        break;
      }
    }
    // _saveCard(event, emit)
    _updateOrderedListTile();
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
    if (editorTiles[0] == toRemove && handOverText == true) {
      return;
    }
    var highestFocusNodeTile = -1;
    for (var i = 0; i < editorTiles.length; i++) {
      if (editorTiles[i] == toRemove) {
        editorTiles.remove(editorTiles[i]);
        for (var j = i - 1; j >= 0; j--) {
          if (editorTiles[j].focusNode != null) {
            if (handOverText == false) {
              editorTiles[j].focusNode?.requestFocus();
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
    _updateOrderedListTile();
  }

  void _updateOrderedListTile() {
    for (var i = 0; i < editorTiles.length; i++) {
      if (editorTiles[i] is ListEditorTile &&
          (editorTiles[i] as ListEditorTile).orderNumber != 0) {
        if (i != 0 &&
            editorTiles[i - 1] is ListEditorTile &&
            (editorTiles[i - 1] as ListEditorTile).orderNumber != 0) {
          final eTi = editorTiles[i] as ListEditorTile;
          final eTi1 = editorTiles[i - 1] as ListEditorTile;

          if (eTi.orderNumber != eTi1.orderNumber + 1) {
            editorTiles[i] = eTi.copyWith(orderNumber: eTi1.orderNumber + 1);
          }
        } else {
          if ((editorTiles[i] as ListEditorTile).orderNumber != 1) {
            editorTiles[i] =
                (editorTiles[i] as ListEditorTile).copyWith(orderNumber: 1);
          }
        }
      }
    }
  }

  void _changeOrderOfTile(
    TextEditorChangeOrderOfTile event,
    Emitter<TextEditorState> emit,
  ) {
    if (event.oldIndex < event.newIndex) {
      event.newIndex -= 1;
    }
    final item = editorTiles.removeAt(event.oldIndex);
    editorTiles.insert(event.newIndex, item);
    emit(TextEditorEditorTilesChanged(tiles: List.of(editorTiles)));
  }

  FutureOr<void> _focusLastWidget(
    TextEditorFocusLastWidget event,
    Emitter<TextEditorState> emit,
  ) {
    final lastWidget = editorTiles[editorTiles.length - 1];
    if ((lastWidget.textFieldController != null &&
            lastWidget.textFieldController!.text.isNotEmpty) ||
        lastWidget.textFieldController == null ||
        lastWidget.focusNode == null) {
      final newFocusNode = FocusNode();
      editorTiles.add(
        TextTile(
          textStyle: TextFieldConstants.normal,
          focusNode: newFocusNode,
        ),
      );
      newFocusNode.requestFocus();
      emit(TextEditorEditorTilesChanged(tiles: List.of(editorTiles)));
    } else {
      lastWidget.focusNode!.requestFocus();
    }
    // _saveEditorTiles();
  }

  void _saveEditorTiles() {
    _saveEditorTilesCallback(editorTiles);
  }

  void _defaultEditorTiles(BuildContext context) {
    editorTiles = [
      TextTile(
        textStyle: TextFieldConstants.normal,
      ),
    ];
  }

  FutureOr<void> _nextCard(
    TextEditorNextCard event,
    Emitter<TextEditorState> emit,
  ) {
    _saveEditorTiles();
    if (parentId != null) {
      Navigator.of(event.context).pushReplacementNamed(
        '/add_card',
        arguments: [
          Card(
            uid: Uid().uid(),
            dateCreated: DateTime.now(),
            askCardsInverted: false,
            typeAnswer: false,
            recallScore: 0,
            dateToReview: DateTime.now(),
            name: '',
          ),
          parentId,
        ],
      );
    } else {
      Navigator.pop(event.context);
    }
  }

  FutureOr<void> _setFocusedWidget(
    TextEditorSetFocusedWidget event,
    Emitter<TextEditorState> emit,
  ) {
    _focusedWidget = event.focusedWidget;
  }

  FutureOr<void> _addWidgetAboveSeparator(
    TextEditorAddWidgetAboveSeparator event,
    Emitter<TextEditorState> emit,
  ) {
    for (var i = 0; i < editorTiles.length; i++) {
      if (editorTiles[i] is FrontBackSeparatorTile) {
        if (i > 0) {
          final textTile = TextTile(textStyle: TextFieldConstants.normal);
          // all editorTiles behind focused tile
          final sublist = editorTiles.sublist(i);
          editorTiles
            ..removeRange(i, editorTiles.length)
            ..add(textTile);
          textTile.focusNode!.requestFocus();
          for (var j = 0; j < sublist.length; j++) {
            editorTiles.add(sublist[j]);
          }
          // _addEditorTile(
          //   TextTile(textStyle: TextFieldConstants.normal),
          //   event.context,
          //   i - 1,
          // );
          emit(TextEditorEditorTilesChanged(tiles: List.of(editorTiles)));
        }
        return null;
      }
    }
  }

  FutureOr<void> _focusWidgetAfterSeparator(
    TextEditorFocusWidgetAfterSeparator event,
    Emitter<TextEditorState> emit,
  ) {
    for (var i = 0; i < editorTiles.length; i++) {
      if (editorTiles[i] is FrontBackSeparatorTile) {
        if (editorTiles.length > i + 1) {
          if (editorTiles[i + 1].focusNode != null) {
            editorTiles[i + 1].focusNode!.requestFocus();
          }
        }
        return null;
      }
    }
  }
}
