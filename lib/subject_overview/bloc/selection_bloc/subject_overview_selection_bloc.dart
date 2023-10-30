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
    on<SubjectOverviewSelectionMoveSelection>(_moveSelection);
    on<SubjectOverviewDraggingChange>(_toggleDragging);
    on<SubjectOverviewSetSoftSelectFolder>(_setSoftSelectFolder);
  }
  final CardsRepository _cardsRepository;

  final ValueNotifier<List<String>> _selectedFilesNotifier = ValueNotifier([]);

  List<String> get selectedFiles => _selectedFilesNotifier.value;
  ValueNotifier<List<String>> get selectedFilesNotifier =>
      _selectedFilesNotifier;

  String _folderUIDSoftSelected = '';
  String get folderUIDSoftSelected => _folderUIDSoftSelected;

  bool _isInDragging = false;
  bool get isInDragging => _isInDragging;

  bool _isInSelectMode = false;
  bool get isInSelectMode => _isInSelectMode;

  bool isFileSelected(String fileUID) {
    return _selectedFilesNotifier.value.contains(fileUID);
  }

  void _clearSelectionVariables() {
    _selectedFilesNotifier.value.clear();
  }

  void _checkIfNothingSelected() {
    if (_selectedFilesNotifier.value.isEmpty &&
        state is SubjectOverviewSelectionModeOn) {
      _isInSelectMode = false;
      emit(SubjectOverviewSelectionModeOff());
    } else {
      emit(SubjectOverviewSelectionModeOn());
    }
  }

  bool _checkIfParentIsSelected(String parentUID, String fileUID) {
    if (_selectedFilesNotifier.value.contains(parentUID)) {
      //select all children
      _cardsRepository
          .getChildrenDirectlyBelow(parentUID)
          .forEach(_selectedFilesNotifier.value.add);

      //deselect parentFolder
      _deselectFolder(
          _cardsRepository.getParentIdFromChildId(parentUID), parentUID);

      //deselect file
      _selectedFilesNotifier.value.remove(fileUID);

      return true;
    } else {
      return false;
    }
  }

  void _checkForLastSelectedInFolder(String parentUID) {
    if (_cardsRepository
        .getChildrenDirectlyBelow(parentUID)
        .every(_selectedFilesNotifier.value.contains)) {
      //select parentFolder
      _selectFolder(
          _cardsRepository.getParentIdFromChildId(parentUID), parentUID);

      //deselect all children
      _cardsRepository
          .getChildrenDirectlyBelow(parentUID)
          .forEach(_selectedFilesNotifier.value.remove);
    }
  }

  void _selectFolder(String parentUID, String folderUID) {
    if (!_checkIfParentIsSelected(parentUID, folderUID)) {
      //select folder
      _selectedFilesNotifier.value.add(folderUID);
      //deselect all childern
      _cardsRepository
          .getChildrenList(folderUID)
          .forEach(_selectedFilesNotifier.value.remove);
      //check if lastSelectedInParentFolder
      _checkForLastSelectedInFolder(parentUID);
    }
    ;
  }

  void _deselectFolder(String parentUID, String folderUID) {
    _selectedFilesNotifier.value.remove(folderUID);
    _checkIfNothingSelected();
  }

  bool _isRootFile(String parentUID, String fileUID) {
    if (_cardsRepository.objectFromId(parentUID) is Subject) {
      //just select or deselect file
      if (_selectedFilesNotifier.value.contains(fileUID)) {
        _selectedFilesNotifier.value.remove(fileUID);
        _checkIfNothingSelected();
      } else {
        _selectedFilesNotifier.value.add(fileUID);
        emit(SubjectOverviewSelectionModeOn());

        //deselect all childern
        if (_cardsRepository.objectFromId(fileUID) is Folder) {
          _cardsRepository
              .getChildrenList(fileUID)
              .forEach(_selectedFilesNotifier.value.remove);
        }
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
      if (!_selectedFilesNotifier.value.contains(event.cardUID)) {
        if (!_checkIfParentIsSelected(parentUID, event.cardUID)) {
          // new Card selected
          _selectedFilesNotifier.value.add(event.cardUID);

          //check if all are selected
          _checkForLastSelectedInFolder(parentUID);
        }
        emit(SubjectOverviewSelectionModeOn());
      } else {
        //deselect card
        _selectedFilesNotifier.value.remove(event.cardUID);

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
      if (_selectedFilesNotifier.value.contains(event.folderUID)) {
        _deselectFolder(parentUID, event.folderUID);
      } else {
        _selectFolder(parentUID, event.folderUID);
        emit(SubjectOverviewSelectionModeOn());
      }
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
    await _cardsRepository.deleteCards(_selectedFilesNotifier.value
        .where((element) => _cardsRepository.objectFromId(element) is Card)
        .toList());
    await _cardsRepository.deleteFolders(_selectedFilesNotifier.value
        .where((element) => _cardsRepository.objectFromId(element) is Folder)
        .toList());

    _isInSelectMode = false;
    _clearSelectionVariables();
    emit(SubjectOverviewSelectionModeOff());
  }

  Future<FutureOr<void>> _moveSelection(
    SubjectOverviewSelectionMoveSelection event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) async {
    await _cardsRepository.moveFiles(selectedFiles, event.parentId);
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
    if (event.folderUID != '') {
      emit(SubjectOverviewSoftSelectionModeOn());
    } else {
      emit(SubjectOverviewSelectionModeOff());
    }
  }
}
