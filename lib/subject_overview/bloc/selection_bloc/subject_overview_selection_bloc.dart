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
    on<SubjectOverviewSelectionDeleteSelectedFiles>(_deleteSelectedFiles);
    on<SubjectOverviewSelectionMoveSelectedCards>(_moveSelectedCards);
    on<SubjectOverviewDraggingChange>(_toggleDragging);
    on<SubjectOverviewSetSoftSelectFolder>(_setSoftSelectFolder);
  }
  final CardsRepository _cardsRepository;

  final List<String> _selectedFiles = List.empty(growable: true);
  List<String> get selectedFiles => _selectedFiles;

  String _folderUIDSoftSelected = '';
  String get folderUIDSoftSelected => _folderUIDSoftSelected;

  bool _isInDragging = false;
  bool get isInDragging => _isInDragging;

  bool _isInSelectMode = false;
  bool get isInSelectMode => _isInSelectMode;

  bool isFileSelected(String fileUID) {
    return _selectedFiles.contains(fileUID);
  }

  void _clearSelectionVariables() {
    _selectedFiles.clear();
  }

  _checkIfNothingSelected() {
    if (_selectedFiles.isEmpty && state is SubjectOverviewSelectionModeOn) {
      _isInSelectMode = false;
      emit(SubjectOverviewSelectionModeOff());
    }
  }

  _checkIfParentWasSelected(String parentUID) {
    if (_selectedFiles.contains(parentUID)) {
      //deselect parentFolder
      _deselectFolder(
          _cardsRepository.getParentIdFromChildId(parentUID), parentUID);

      //select all children
      _cardsRepository
          .getChildrenDirectlyBelow(parentUID)
          .forEach(_selectedFiles.add);

      print('parent deselected');
    }
  }

  _checkForLastSelectedInFolder(String parentUID) {
    if (_cardsRepository
        .getChildrenDirectlyBelow(parentUID)
        .every(_selectedFiles.contains)) {
      //select parentFolder
      _selectFolder(
          _cardsRepository.getParentIdFromChildId(parentUID), parentUID);

      //deselect all children
      _cardsRepository
          .getChildrenDirectlyBelow(parentUID)
          .forEach(_selectedFiles.remove);

      print('parent selected');
    }
  }

  _selectFolder(String parentUID, String folderUID) {
    //select folder
    _selectedFiles.add(folderUID);
    //deselect all childern
    _cardsRepository.getChildrenList(folderUID).forEach(_selectedFiles.remove);
    //check if lastSelectedInParentFolder
    _checkForLastSelectedInFolder(parentUID);
  }

  _deselectFolder(String parentUID, String folderUID) {
    _checkIfParentWasSelected(parentUID);
    _selectedFiles.remove(folderUID);
  }

  bool _isRootFile(String parentUID, String fileUID) {
    if (_cardsRepository.objectFromId(parentUID) is Subject) {
      //just select or deselect file
      if (_selectedFiles.remove(fileUID) == false) {
        _selectedFiles.add(fileUID);
      }
      return true;
    }
    return false;
  }

  FutureOr<void> _changeCardSelection(
    SubjectOverviewCardSelectionChange event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    final parentUID = _cardsRepository.getParentIdFromChildId(event.cardUID);

    if (!_isRootFile(parentUID, event.cardUID)) {
      if (!_selectedFiles.contains(event.cardUID)) {
        // new Card selected
        _selectedFiles.add(event.cardUID);

        //check if all are selected
        _checkForLastSelectedInFolder(parentUID);
      } else {
        //check if parentFolder is Selected
        _checkIfParentWasSelected(parentUID);

        //deselect card
        _selectedFiles.remove(event.cardUID);

        _checkIfNothingSelected();
      }
    }
  }

  FutureOr<void> _changeFolderSelection(
    SubjectOverviewFolderSelectionChange event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    final parentUID = _cardsRepository.getParentIdFromChildId(event.folderUID);
    if (!_isRootFile(parentUID, event.folderUID)) {
      _selectedFiles.contains(event.folderUID)
          ? _deselectFolder(parentUID, event.folderUID)
          : _selectFolder(parentUID, event.folderUID);
    }
  }

  FutureOr<void> _toggleSelectMode(
    SubjectOverviewSelectionToggleSelectMode event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    if (event.inSelectMode) {
      _isInSelectMode = true;
      _folderUIDSoftSelected = '';
      emit(SubjectOverviewSelectionModeOn());
    } else {
      _isInSelectMode = false;
      _clearSelectionVariables();
      emit(SubjectOverviewSelectionModeOff());
    }
  }

  FutureOr<void> _deleteSelectedFiles(
    SubjectOverviewSelectionDeleteSelectedFiles event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) async {
    await _cardsRepository.deleteCards(_selectedFiles
        .where((element) => _cardsRepository.objectFromId(element) is Card)
        .toList());
    await _cardsRepository.deleteFolders(_selectedFiles
        .where((element) => _cardsRepository.objectFromId(element) is Folder)
        .toList());

    _isInSelectMode = false;
    _clearSelectionVariables();
    emit(SubjectOverviewSelectionModeOff());
  }

  Future<FutureOr<void>> _moveSelectedCards(
    SubjectOverviewSelectionMoveSelectedCards event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) async {
    //TODO make moveCards and moveFolder with UIDs
    print('move is not ready');
    // await _cardsRepository.moveCards(
    //     selectedFiles
    //         .where((element) => _cardsRepository.objectFromId(element) is Card)
    //         .toList(),
    //     event.parentId);

    // await _cardsRepository.moveFolders(
    //     selectedFiles
    //         .where((element) => _cardsRepository.objectFromId(element) is Folder)
    //         .toList(),
    //     event.parentId);

    _clearSelectionVariables();
    emit(SubjectOverviewSelectionModeOff());
  }

  FutureOr<void> _toggleDragging(
    SubjectOverviewDraggingChange event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    if (event.inDragg && _isInDragging == false) {
      _isInDragging = true;
      if (_isInSelectMode) {
        emit(SubjectOverviewSelectionMultiDragging());
      }
    } else if (!event.inDragg && _isInDragging == true) {
      _isInDragging = false;
      if (_isInSelectMode) {
        emit(SubjectOverviewSelectionModeOn());
      }
    }
  }

  FutureOr<void> _setSoftSelectFolder(SubjectOverviewSetSoftSelectFolder event,
      Emitter<SubjectOverviewSelectionState> emit) {
    _folderUIDSoftSelected = event.folderUID;
    if (event.folderUID != '')
      emit(SubjectOverviewSoftSelectionModeOn());
    else
      emit(SubjectOverviewSelectionModeOff());
  }
}
