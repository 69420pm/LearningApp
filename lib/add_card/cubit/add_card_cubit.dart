import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:intl/intl.dart';
import 'package:learning_app/editor/helper/data_class_helper.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/models/text_field_constants.dart';
import 'package:learning_app/editor/widgets/editor_tiles/front_back_seperator_tile.dart';
import 'package:learning_app/editor/widgets/editor_tiles/header_tile.dart';
import 'package:learning_app/editor/widgets/editor_tiles/text_tile.dart';

part 'add_card_state.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit(this.cardsRepository) : super(AddCardInitial());

  final CardsRepository cardsRepository;

  Future<void> saveCard(
    Card card,
    String? parentId,
    List<EditorTile>? editorTiles,
  ) async {
    emit(AddCardLoading());
    if (editorTiles != null) {
      if ((card.name.isEmpty && card.name.trim().isEmpty) ||
          card.name.startsWith('created on ') && card.name.length == 31) {
        card.name = getCardName(editorTiles);
      }
    }
    await cardsRepository.saveCard(card, editorTiles, parentId);
    emit(AddCardSuccess());
  }

  Future<List<EditorTile>> getSavedEditorTiles(
    Card card,
  ) async {
    var loadedEditorTiles = await cardsRepository.getCardContent(card.uid);
    if (loadedEditorTiles.isNotEmpty) {
    } else {
      loadedEditorTiles = [
        HeaderTile(
          hintText: 'Front',
          textStyle: TextFieldConstants.headingSmall,
          key: UniqueKey()
        ),
        FrontBackSeparatorTile(key: UniqueKey()),
        TextTile(
          textStyle: TextFieldConstants.normal,
          hintText: 'Back',
          key: UniqueKey()

        ),
      ];
    }
    return loadedEditorTiles;
  }

  String getCardName(List<EditorTile> editorTiles) {
    final frontText =
        DataClassHelper.getFrontAndBackTextFromEditorTiles(editorTiles, true);
    if (frontText.isNotEmpty && frontText[0].trim().isNotEmpty) {
      final newlineIndex = frontText[0].indexOf("\n");
      if (newlineIndex != -1) {
        return frontText[0].substring(0, newlineIndex);
      } else {
        return frontText[0];
      }
    } else {
      return "created on ${DateFormat('EEE dd.MM yyyy HH:mm').format(DateTime.now())}";
    }
  }
}
