import 'dart:async';

import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';

part 'folder_list_tile_event.dart';
part 'folder_list_tile_state.dart';

class FolderListTileBloc
    extends Bloc<FolderListTileEvent, FolderListTileState> {
  FolderListTileBloc(this.cardsRepository) : super(FolderListTileInitial()) {
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

    // on<FolderListTileCloseStreamById>(_closeStream);

    on<FolderListTileDEBUGAddCard>(_debugAddCard);
    on<FolderListTileClearHovers>(_clearHovers);
    on<FolderListTileUpdate>(_folderUpdate);
    on<FolderListTileChangeFolderName>(_changeFolderName);
  }
  // List<String> _subscribedStreamIds = [];

  final CardsRepository cardsRepository;
  bool isDragging = false;

  String? streamId;
  Future<void> _getChildren(
    FolderListTileGetChildrenById event,
    Emitter<FolderListTileState> emit,
  ) async {
    // emit(FolderListTileLoading());
    // await _cardsRepository.closeStreamById(streamId!);

    // await emit.forEach(
    //   _cardsRepository.getChildrenById(event.id),
    //   onData: (data) {
    //     final childListTiles = <String, Widget>{};
    //     final widgetsToRemove = <Removed>[];
    //     for (final element in data) {
    //       if (element is Folder) {
    //         childListTiles[element.id] = FolderListTileParent(
    //           folder: element,
    //           // cardsRepository: _cardsRepository,
    //         );
    //       } else if (element is Card) {
    //         childListTiles[element.id] = CardListTile(
    //           card: element,
    //           isCardSelected: false,
    //           isInSelectMode: false,
    //         );
    //       } else if (element is Removed) {
    //         widgetsToRemove.add(element);
    //       }
    //     }
    //     // if (childListTiles.isNotEmpty || widgetsToRemove.isNotEmpty) {
    //     return FolderListTileRetrieveChildren(
    //       senderId: event.id,
    //       childrenStream: childListTiles,
    //       removedWidgets: widgetsToRemove,
    //     );
    //     // }

    //     // return FolderListTileSuccess();
    //   },
    //   onError: (error, stackTrace) =>
    //       FolderListTileError(errorMessage: 'backend broken'),
    // );
  }

  Future<void> _addFolder(
    FolderListTileAddFolder event,
    Emitter<FolderListTileState> emit,
  ) async {
    emit(FolderListTileLoading());
    // try {
    await cardsRepository.saveFolder(event.folder, event.newParentId);
    await cardsRepository.deleteFolders([event.folder.uid]);
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
    await cardsRepository.deleteCards([event.card.uid]);
    await cardsRepository.saveCard(event.card, event.newParentId);
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
    await cardsRepository.deleteFolders([event.id]);
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
    await cardsRepository.moveFolders([event.folder], event.newParentId);
    emit(FolderListTileSuccess());
    // } catch (e) {
    //   emit(FolderListTileError(errorMessage: "folder moving failed"));
    // }
  }

  Future<FutureOr<void>> _debugAddCard(
    FolderListTileDEBUGAddCard event,
    Emitter<FolderListTileState> emit,
  ) async {
    // await cardsRepository.saveCard(event.card);
  }

  // FutureOr<void> _closeStream(FolderListTileCloseStreamById event, Emitter<FolderListTileState> emit) {
  //   _cardsRepository.closeStreamById(event.id);
  // }
  @override
  Future<void> close() async {
    if (streamId != null) {
      // await _cardsRepository.closeStreamById(streamId!);
    }
    return super.close();
  }

  Widget folderWidget(Folder element) {
    return BlocProvider(
      create: (context) => FolderListTileBloc(cardsRepository),
      child: FolderListTileParent(
        folder: element,
        // cardsRepository: _cardsRepository,
      ),
    );
  }

  FutureOr<void> _folderUpdate(
    FolderListTileUpdate event,
    Emitter<FolderListTileState> emit,
  ) {
    isDragging = true;
    emit(FolderListTileUpdateOnHover(event.id));
  }

  FutureOr<void> _clearHovers(
    FolderListTileClearHovers event,
    Emitter<FolderListTileState> emit,
  ) {
    isDragging = false;
    emit(FolderListTileToClearHover());
  }

  FutureOr<void> _changeFolderName(FolderListTileChangeFolderName event,
      Emitter<FolderListTileState> emit) async {
    emit(FolderListTileLoading());
    // try {
    await cardsRepository.saveFolder(
        event.folder.copyWith(name: event.newName), null);
    emit(FolderListTileSuccess());
  }
}
