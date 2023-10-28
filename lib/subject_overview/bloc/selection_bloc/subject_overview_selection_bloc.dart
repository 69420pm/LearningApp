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
  }
  final CardsRepository _cardsRepository;
  final List<String> selectedFiles = List.empty(growable: true);

  Folder? folderSoftSelected;
  bool isInDragging = false;
  bool isInSelectMode = false;

  void _clearSelectionVariables() {
    selectedFiles.clear();
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
    if (!selectedFiles.contains(event.cardUID)) {
      // new Card selected
      selectedFiles.add(event.cardUID);
      if () {
        //change list
        (selectedInFolder[event.parentFolder!.uid]![1]
            as Map<Card, bool>)[event.card] = true;

        //check if all are selected
        if (!selectedInFolder[event.parentFolder!.uid]![0]
                .containsValue(false) &&
            !selectedInFolder[event.parentFolder!.uid]![1]
                .containsValue(false)) {
          //add folder to selectedfolders
          foldersSelected.add(event.parentFolder!);
          (selectedInFolder[event.parentFolder!.uid]![0]
              as Map<Folder, bool>)[event.parentFolder!] = true;

          //deselect all childs
          (selectedInFolder[event.parentFolder!.uid]![0] as Map<Folder, bool>)
              .forEach((key, value) {
            foldersSelected.remove(key);
            value = false;
          });
          (selectedInFolder[event.parentFolder!.uid]![1] as Map<Card, bool>)
              .forEach((key, value) {
            cardsSelected.remove(key);
            value = false;
          });
          print("parent selected");
          emit(SubjectOverviewSelectionModeOn());
        } else {
          print("not all selected");
        }
      } else {
        print("root");
      }
    } else {
      // removed from selection

      if (event.parentFolder != null) {
        //check if parentFolder is Selected
        if (foldersSelected.contains(event.parentFolder)) {
          //deselect parentfolder
          foldersSelected.remove(event.parentFolder);
          // (selectedInFolder[event.parentFolder!.parentId]![0]
          // as Map<Folder, bool>)[event.parentFolder!] = false;
          //select all childs
          (selectedInFolder[event.parentFolder!.uid]![0] as Map<Folder, bool>)
              .forEach((key, value) {
            foldersSelected.add(key);
            value = true;
          });
          (selectedInFolder[event.parentFolder!.uid]![1] as Map<Card, bool>)
              .forEach((key, value) {
            cardsSelected.add(key);
            value = true;
          });
          print("parent deselected");
          emit(SubjectOverviewSelectionModeOn());
        }
        //deselect card
        cardsSelected.remove(event.card);
        // (selectedInFolder[event.parentFolder!.parentId]![1]
        //     as Map<Card, bool>)[event.card] = false;
      } else {
        print("root");
      }
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
      // (selectedInFolder[event.folder.parentId]![0]
      //     as Map<Folder, bool>)[event.folder] = true;
      //check if all are selected
      // if (!selectedInFolder[event.folder.parentId]![0].containsValue(false) &&
      //     !selectedInFolder[event.folder.parentId]![1].containsValue(false)) {
      //   //add folder to selectedfolders
      //   foldersSelected.add(event.folder.parentId);
      //   (selectedInFolder[event.parentFolder!.uid]![0]
      //       as Map<Folder, bool>)[event.parentFolder!] = true;

      //   //deselect all childs
      //   (selectedInFolder[event.parentFolder!.uid]![0] as Map<Folder, bool>)
      //       .forEach((key, value) {
      //     foldersSelected.remove(key);
      //     value = false;
      //   });
      //   (selectedInFolder[event.parentFolder!.uid]![1] as Map<Card, bool>)
      //       .forEach((key, value) {
      //     cardsSelected.remove(key);
      //     value = false;
      //   });
      //   print("parent selected");
      //   emit(SubjectOverviewSelectionModeOn());
      // } else {
      //   print("not all selected");
      // }
      //deselect all children
    } else {
      // removed from selection
      foldersSelected.remove(event.folder);
      // (selectedInFolder[event.folder.parentId]![0]
      //     as Map<Folder, bool>)[event.folder] = false;
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
      ids.add(cardsSelected[i].uid);
      // parentIds.add(cardsSelected[i].parentId);
    }
    // await _cardsRepository.deleteCards(ids, parentIds);

    isInSelectMode = false;
    _clearSelectionVariables();
    emit(SubjectOverviewSelectionModeOff());
  }

  Future<FutureOr<void>> _moveSelectedCards(
    SubjectOverviewSelectionMoveSelectedCards event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) async {
    // cardsSelected.removeWhere((element) => element.parentId == event.parentId);
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
      selectedInFolder[event.folderId] = [event.folder, event.cards];
    } else {
      selectedInFolder[event.folderId] = [event.folder, event.cards];
      emit(SubjectOverviewSelectionModeOff());
    }
  }
}
