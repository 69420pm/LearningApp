import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;

part 'subject_overview_selection_event.dart';
part 'subject_overview_selection_state.dart';

class SubjectOverviewSelectionBloc
    extends Bloc<SubjectOverviewSelectionEvent, SubjectOverviewSelectionState> {
  SubjectOverviewSelectionBloc(this._cardsRepository)
      : super(SubjectOverviewSelectionInitial()) {
    on<SubjectOverviewSelectionToggleSelectMode>(_toggleSelectMode);
    on<SubjectOverviewCardSelectionChange>(_changeCardSelection);
    on<SubjectOverviewFolderSelectionChange>(_changeFolderSelection);
    on<SubjectOverviewSelectionDeleteSelectedCards>(_deleteCards);
    on<SubjectOverviewSelectionMoveSelectedCards>(_moveSelectedCards);
    on<SubjectOverviewDraggingChange>(_toggleDragging);
    on<SubjectOverviewSetSoftSelectFolder>(_setSoftSelectFolder);
    on<SubjectOverviewUpdateFolderTable>(_updateFolderTable);
    on<SubjectOverviewChangeSelectionInFolderTable>(_changeFolderTable);
  }
  final CardsRepository _cardsRepository;
  final List<Card> cardsSelected = List.empty(growable: true);
  final List<Folder> foldersSelected = List.empty(growable: true);

  Folder? folderSoftSelected;
  bool isInDragging = false;
  bool isInSelectMode = false;

  final Map<String, List<int>> selectedInFolder = {};

  void _clearSelectionVariables() {
    cardsSelected.clear();
    foldersSelected.clear();
    selectedInFolder.forEach((key, value) {
      value[1] = 0;
    });
  }

  FutureOr<void> _toggleSelectMode(
    SubjectOverviewSelectionToggleSelectMode event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    if (event.inSelectMode) {
      isInSelectMode = true;
      folderSoftSelected = null;
      emit(SubjectOverviewSelectionModeOn());
    } else {
      isInSelectMode = false;
      _clearSelectionVariables();
      emit(SubjectOverviewSelectionModeOff());
    }
  }

  FutureOr<void> _changeCardSelection(
    SubjectOverviewCardSelectionChange event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    if (!cardsSelected.contains(event.card)) {
      // new Card selected
      cardsSelected.add(event.card);
    } else {
      // removed from selection
      cardsSelected.remove(event.card);
      if (cardsSelected.isEmpty &&
          foldersSelected.isEmpty &&
          state is SubjectOverviewSelectionModeOn) {
        // if last card removed from selection, selection mode off
        isInSelectMode = false;
        emit(SubjectOverviewSelectionModeOff());
      }
    }
  }

  FutureOr<void> _changeFolderSelection(
    SubjectOverviewFolderSelectionChange event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    if (!foldersSelected.contains(event.folder)) {
      // new selected
      foldersSelected.add(event.folder);
    } else {
      // removed from selection
      foldersSelected.remove(event.folder);
      if (cardsSelected.isEmpty &&
          foldersSelected.isEmpty &&
          state is SubjectOverviewSelectionModeOn) {
        // if last card removed from selection, selection mode off
        isInSelectMode = false;
        emit(SubjectOverviewSelectionModeOff());
      }
    }
  }

  FutureOr<void> _deleteCards(
    SubjectOverviewSelectionDeleteSelectedCards event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) async {
    final ids = <String>[];
    final parentIds = <String>[];
    for (var i = 0; i < cardsSelected.length; i++) {
      ids.add(cardsSelected[i].id);
      parentIds.add(cardsSelected[i].parentId);
    }
    await _cardsRepository.deleteCards(ids, parentIds);
    isInSelectMode = false;
    _clearSelectionVariables();
    emit(SubjectOverviewSelectionModeOff());
  }

  Future<FutureOr<void>> _moveSelectedCards(
    SubjectOverviewSelectionMoveSelectedCards event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) async {
    cardsSelected.removeWhere((element) => element.parentId == event.parentId);
    await _cardsRepository.moveCards(cardsSelected, event.parentId);
    cardsSelected.clear();
    foldersSelected.clear();
    isInSelectMode = false;
    emit(SubjectOverviewSelectionModeOff());
  }

  FutureOr<void> _toggleDragging(
    SubjectOverviewDraggingChange event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    if (event.inDragg && isInDragging == false) {
      isInDragging = true;
      if (isInSelectMode) {
        emit(SubjectOverviewSelectionMultiDragging());
      }
    } else if (!event.inDragg && isInDragging == true) {
      isInDragging = false;
      if (isInSelectMode) {
        emit(SubjectOverviewSelectionModeOn());
      }
    }
  }

  FutureOr<void> _setSoftSelectFolder(SubjectOverviewSetSoftSelectFolder event,
      Emitter<SubjectOverviewSelectionState> emit) {
    folderSoftSelected = event.folder;
    if (event.folder != null)
      emit(SubjectOverviewSoftSelectionModeOn());
    else
      emit(SubjectOverviewSelectionModeOff());
  }

  FutureOr<void> _updateFolderTable(SubjectOverviewUpdateFolderTable event,
      Emitter<SubjectOverviewSelectionState> emit) {
    if (selectedInFolder.containsKey(event.folderId)) {
      selectedInFolder[event.folderId]?[0] = event.numberOfChildren;
    } else {
      selectedInFolder[event.folderId] = [event.numberOfChildren, 0];
    }
  }

  FutureOr<void> _changeFolderTable(
      SubjectOverviewChangeSelectionInFolderTable event,
      Emitter<SubjectOverviewSelectionState> emit) {
    selectedInFolder[event.folderId]?[1] += event.select ? 1 : -1;
  }
}
