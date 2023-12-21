import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';import 'package:learning_app/card_backend/cards_repository.dart';
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
    on<SubjectOverviewSetSoftSelectFile>(_setSoftSelectFile);
    on<SubjectOverviewSetHoveredFolder>(_setHoveredFolder);
    on<SubjectOverviewSelectAll>(_selectAll);
  }
  final CardsRepository _cardsRepository;

  final List<String> _selectedFiles = List.empty(growable: true);
  List<String> get selectedFiles => _selectedFiles;

  String _fileSoftSelected = '';
  String get fileSoftSelected => _fileSoftSelected;

  bool _isInDragging = false;
  bool get isInDragging => _isInDragging;

  String _fileDragged = '';
  String get fileDragged => _fileDragged;

  String _hoveredFoldeUID = '';
  String get hoveredFolderUID => _hoveredFoldeUID;

  bool _isInSelectMode = false;
  bool get isInSelectMode => _isInSelectMode;

  bool isFileSelected(String fileUID) {
    return _selectedFiles.contains(fileUID);
  }

  void _clearSelectionVariables() {
    _selectedFiles.clear();
  }

  void _checkIfNothingSelected() {
    if (_selectedFiles.isEmpty && state is SubjectOverviewSelectionModeOn) {
      _isInSelectMode = false;
      emit(SubjectOverviewSelectionModeOff());
    } else {
      emit(SubjectOverviewSelectionModeOn());
    }
  }

  bool _checkIfParentIsSelected(String parentUID, String fileUID) {
    String? selectedParentFolderUID;

    if (_selectedFiles.contains(parentUID)) {
      selectedParentFolderUID = parentUID;
    } else {
      _cardsRepository.getParentIdsFromChildId(parentUID).forEach((element) {
        if (_selectedFiles.contains(element)) {
          selectedParentFolderUID = element;
          return;
        }
      });
    }

    if (selectedParentFolderUID != null) {
      //select all children
      _cardsRepository
          .getChildrenDirectlyBelow(selectedParentFolderUID!)
          .forEach(_selectedFiles.add);

      //deselect parentFolder
      _deselectFolder(
        _cardsRepository.getParentIdFromChildId(selectedParentFolderUID!),
        selectedParentFolderUID!,
      );

      if (selectedParentFolderUID != parentUID) {
        //!rekursion
        _checkIfParentIsSelected(parentUID, fileUID);
      } else {
        //deselect file
        _selectedFiles.remove(fileUID);

        _checkIfNothingSelected();
      }

      return true;
    } else {
      return false;
    }
  }

  void _selectFolder(String parentUID, String folderUID) {
    if (!_checkIfParentIsSelected(parentUID, folderUID)) {
      //select folder
      _selectedFiles.add(folderUID);
      //deselect all childern
      _cardsRepository
          .getChildrenList(folderUID)
          .forEach(_selectedFiles.remove);
    }
  }

  void _deselectFolder(String parentUID, String folderUID) {
    _selectedFiles.remove(folderUID);
    _checkIfNothingSelected();
  }

  bool _isRootFile(String parentUID, String fileUID) {
    if (_cardsRepository.objectFromId(parentUID) is Subject) {
      //just select or deselect file
      if (_selectedFiles.contains(fileUID)) {
        _selectedFiles.remove(fileUID);
        _checkIfNothingSelected();
      } else {
        _selectedFiles.add(fileUID);
        emit(SubjectOverviewSelectionModeOn());

        //deselect all childern
        if (_cardsRepository.objectFromId(fileUID) is Folder) {
          _cardsRepository
              .getChildrenList(fileUID)
              .forEach(_selectedFiles.remove);
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
      if (!_selectedFiles.contains(event.cardUID)) {
        if (!_checkIfParentIsSelected(parentUID, event.cardUID)) {
          // new Card selected
          _selectedFiles.add(event.cardUID);
        }
        emit(SubjectOverviewSelectionModeOn());
      } else {
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
      if (_selectedFiles.contains(event.folderUID)) {
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
      _fileSoftSelected = '';
      _hoveredFoldeUID = '';
      _isInDragging = false;
      emit(SubjectOverviewSelectionModeOn());
    } else {
      _isInSelectMode = false;
      _hoveredFoldeUID = '';
      _isInDragging = false;
      _clearSelectionVariables();
      emit(SubjectOverviewSelectionModeOff());
    }
  }

  FutureOr<void> _deleteSelectedFiles(
    SubjectOverviewSelectionDeleteSelectedFiles event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) async {
    if (event.softSelectedFile != null) {
      await _cardsRepository.deleteFiles([event.softSelectedFile!]);
    } else {
      await _cardsRepository.deleteFiles(_selectedFiles);
    }

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
    _hoveredFoldeUID = '';
    _isInDragging = false;
    _isInSelectMode = false;
    _fileDragged = '';
    emit(SubjectOverviewSelectionModeOff());
  }

  FutureOr<void> _toggleDragging(
    SubjectOverviewDraggingChange event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    if (event.inDragg == true && _isInDragging == false) {
      _isInDragging = true;
      _fileDragged = event.draggedFileUID;
      //if (_isInSelectMode) emit(SubjectOverviewSelectionMultiDragging());
    } else if (event.inDragg == false && _isInDragging == true) {
      _isInDragging = false;
      _hoveredFoldeUID = '';
      _fileDragged = '';
      //if (_isInSelectMode) emit(SubjectOverviewSelectionModeOn());
    }
    if (_isInSelectMode) {
      emit(SubjectOverviewSelectionModeOn());
    }
  }

  FutureOr<void> _setSoftSelectFile(
    SubjectOverviewSetSoftSelectFile event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    _fileSoftSelected = event.fileUID;
    if (event.fileUID != '') {
      emit(SubjectOverviewSoftSelectionModeOn());
    } else {
      emit(SubjectOverviewSelectionModeOff());
    }
  }

  FutureOr<void> _setHoveredFolder(
    SubjectOverviewSetHoveredFolder event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    if (_hoveredFoldeUID != event.folderUID) {
      _hoveredFoldeUID = event.folderUID;
      emit(SubjectOverviewSelectionUpdateHover());
    }
  }

  FutureOr<void> _selectAll(SubjectOverviewSelectAll event,
      Emitter<SubjectOverviewSelectionState> emit) async {
    var childUIDs =
        await _cardsRepository.getChildrenById(event.subjectUID).value;
    for (final file in childUIDs) {
      if (!_selectedFiles.contains(file.uid)) {
        if (file is Folder) {
          _selectFolder(event.subjectUID, file.uid);
        } else if (file is Card) {
          _selectedFiles.add(file.uid);
        }
      }
    }
  }
}
