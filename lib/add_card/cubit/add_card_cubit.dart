import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:intl/intl.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:meta/meta.dart';

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
        ),
        FrontBackSeparatorTile(),
        TextTile(
          textStyle: TextFieldConstants.normal,
          hintText: 'Back',
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
