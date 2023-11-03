import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:meta/meta.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';

part 'add_card_state.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit(this._cardsRepository) : super(AddCardInitial());

  final CardsRepository _cardsRepository;
  bool _editMarkDownMode = false;

  Future<void> saveCard(
    Card card,
    String? parentId,
    List<EditorTile>? editorTiles,
  ) async {
    emit(AddCardLoading());
    await _cardsRepository.saveCard(card, editorTiles, parentId);
    emit(AddCardSuccess());
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
