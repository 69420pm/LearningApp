import 'package:bloc/bloc.dart';
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';

part 'folder_list_tile_event.dart';
part 'folder_list_tile_state.dart';

class FolderListTileBloc
    extends Bloc<FolderListTileEvent, FolderListTileState> {
  FolderListTileBloc(this._cardsRepository) : super(FolderListTileInitial()) {
    on<FolderListTileGetChildrenById>((event, emit) async {
      await _getChildren(event, emit);
    });
  }

  final CardsRepository _cardsRepository;

  Future<void> _getChildren(
    FolderListTileGetChildrenById event,
    Emitter<FolderListTileState> emit,
  ) async {
    emit(FolderListTileLoading());
    await emit.forEach(
      _cardsRepository.getChildrenById(event.id),
      onData: (data) {
        final childListTiles = <String, Widget>{};
        for (final element in data) {
          if (element is Folder) {
            childListTiles[element.id] = FolderListTile(folder: element, cardsRepository: _cardsRepository);
          } else if (element is Card) {
            childListTiles[element.id] = CardListTile(card: element);
          }
        }
        return FolderListTileRetrieveChildren(childrenStream: childListTiles);
      },
      onError: (error, stackTrace) =>
          FolderListTileError(errorMessage: 'backend broken'),
    );
  }
}
