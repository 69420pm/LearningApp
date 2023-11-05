import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:meta/meta.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';

part 'add_card_state.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit(this.cardsRepository) : super(AddCardInitial());

  final CardsRepository cardsRepository;
  bool _editMarkDownMode = false;

  Future<void> saveCard(
    Card card,
    String? parentId,
    List<EditorTile>? editorTiles,
  ) async {
    emit(AddCardLoading());
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
        TextTile(
          textStyle: TextFieldConstants.normal,
          hintText: 'Front',
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

  void switchMarkdownMode() {
    if (_editMarkDownMode) {
      emit(AddCardRenderMode());
    } else {
      emit(AddCardEditMode());
    }
    _editMarkDownMode = !_editMarkDownMode;
  }
}
