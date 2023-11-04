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
    on<FolderListTileAddFolder>(_addFolder);
    on<FolderListTileChangeFolderName>(_changeFolderName);
  }

  final CardsRepository cardsRepository;

  bool isDragging = false;
  String hoveredFolderUID = '';
  String? streamId;

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
        cardsRepository: cardsRepository,
      ),
    );
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
