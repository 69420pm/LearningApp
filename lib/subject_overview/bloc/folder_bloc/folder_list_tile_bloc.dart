import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';

import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile_view.dart';

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
    on<FolderListTileMoveCard>(
      _moveCard,
    );
    on<FolderListTileDeleteFolder>(_deleteFolder);
    on<FolderListTileMoveFolder>(_moveFolder);

    on<FolderListTileDEBUGAddCard>(_debugAddCard);
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
        print("____________________________________");
        print(event.id);
        print(data);
        print("________________________________________");
        final childListTiles = <String, Widget>{};
        final widgetsToRemove = <Removed>[];
        for (final element in data) {
          if (element is Folder) {
            childListTiles[element.id] = FolderListTile(
              folder: element,
              cardsRepository: _cardsRepository,
            );
          } else if (element is Card) {
            childListTiles[element.id] = CardListTile(
              card: element,
              isCardSelected: false,
              isInSelectMode: false,
            );
          } else if (element is Removed) {
            widgetsToRemove.add(element);
          }
        }
        return FolderListTileRetrieveChildren(
          childrenStream: childListTiles,
          removedWidgets: widgetsToRemove,
        );
      },
      onError: (error, stackTrace) =>
          FolderListTileError(errorMessage: 'backend broken'),
    );
  }

  Future<void> _addFolder(
    FolderListTileAddFolder event,
    Emitter<FolderListTileState> emit,
  ) async {
    emit(FolderListTileLoading());
    // try {
    final newFolder = event.folder.copyWith(parentId: event.newParentId);
    await _cardsRepository.saveFolder(newFolder);
    await _cardsRepository.deleteFolder(event.folder.id, event.folder.parentId);
    emit(FolderListTileSuccess());
    // } catch (e) {
    //   emit(FolderListTileError(errorMessage: 'folder adding failed'));
    // }
  }

  Future<void> _moveCard(
    FolderListTileMoveCard event,
    Emitter<FolderListTileState> emit,
  ) async {
    emit(FolderListTileLoading());
    // try {
    final newCard = event.card.copyWith(parentId: event.newParentId);
    await _cardsRepository.deleteCard(event.card.id, event.card.parentId);
    await _cardsRepository.saveCard(newCard);
    emit(FolderListTileSuccess());
    // } catch (e) {
    //   emit(FolderListTileError(errorMessage: 'card adding failed'));
    // }
  }

  FutureOr<void> _deleteFolder(
    FolderListTileDeleteFolder event,
    Emitter<FolderListTileState> emit,
  ) async {
    emit(FolderListTileLoading());
    // try{
    await _cardsRepository.deleteFolder(event.id, event.parentId);
    emit(FolderListTileSuccess());
    // }catch(e){
    //   emit(FolderListTileError(errorMessage: 'folder deleting failed'));
    // }
  }

  Future<FutureOr<void>> _moveFolder(
    FolderListTileMoveFolder event,
    Emitter<FolderListTileState> emit,
  ) async {
    emit(FolderListTileLoading());
    // try {
    await _cardsRepository.moveFolder(event.folder, event.newParentId);
    emit(FolderListTileSuccess());
    // } catch (e) {
    //   emit(FolderListTileError(errorMessage: "folder moving failed"));
    // }
  }

  Future<FutureOr<void>> _debugAddCard(FolderListTileDEBUGAddCard event,
      Emitter<FolderListTileState> emit) async {
    await _cardsRepository.saveCard(event.card);
  }
}
