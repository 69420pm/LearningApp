import 'dart:async';

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
    on<FolderListTileAddFolder>(
      _addFolder,
    );
    on<FolderListTileAddCard>(
      _addCard,
    );
    on<FolderListTileDeleteFolder>(_deleteFolder);
    on<FolderLIstTileMoveFolder>(_moveFolder);
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
        final widgetsToRemove = <Removed>[];
        for (final element in data) {
          if (element is Folder) {
            childListTiles[element.id] = FolderListTile(
                folder: element, cardsRepository: _cardsRepository);
          } else if (element is Card) {
            childListTiles[element.id] = CardListTile(
              card: element,
              cardsRepository: _cardsRepository,
            );
          } else if (element is Removed) {
            widgetsToRemove.add(element);
          }
        }
        return FolderListTileRetrieveChildren(
            childrenStream: childListTiles, removedWidgets: widgetsToRemove);
      },
      onError: (error, stackTrace) =>
          FolderListTileError(errorMessage: 'backend broken'),
    );
  }

  Future<void> _addFolder(
      FolderListTileAddFolder event, Emitter<FolderListTileState> emit) async {
    emit(FolderListTileLoading());
    try {
      final newFolder = event.folder.copyWith(parentId: event.newParentId);
      await _cardsRepository.saveFolder(newFolder);
      emit(FolderListTileSuccess());
    } catch (e) {
      emit(FolderListTileError(errorMessage: 'folder adding failed'));
    }
  }

  Future<void> _addCard(
      FolderListTileAddCard event, Emitter<FolderListTileState> emit) async {
    emit(FolderListTileLoading());
    try {
      final newCard = event.card.copyWith(parentId: event.newParentId);
      await _cardsRepository.saveCard(newCard);
      emit(FolderListTileSuccess());
    } catch (e) {
      emit(FolderListTileError(errorMessage: 'card adding failed'));
    }
  }

  FutureOr<void> _deleteFolder(FolderListTileDeleteFolder event,
      Emitter<FolderListTileState> emit) async {
    emit(FolderListTileLoading());
    // try{
    await _cardsRepository.deleteFolder(event.id, event.parentId);
    emit(FolderListTileSuccess());
    // }catch(e){
    //   emit(FolderListTileError(errorMessage: 'folder deleting failed'));
    // }
  }

  Future<FutureOr<void>> _moveFolder(
      FolderLIstTileMoveFolder event, Emitter<FolderListTileState> emit) async {
    emit(FolderListTileLoading());
    print("movjdv");
    await _cardsRepository.moveFolder(
        event.id, event.previousParentId, event.newParentId);
    emit(FolderListTileSuccess());
  }
}
