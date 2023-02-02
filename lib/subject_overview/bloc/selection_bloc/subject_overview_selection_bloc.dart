import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;

part 'subject_overview_selection_event.dart';
part 'subject_overview_selection_state.dart';

class SubjectOverviewSelectionBloc
    extends Bloc<SubjectOverviewSelectionEvent, SubjectOverviewSelectionState> {
  SubjectOverviewSelectionBloc(this._cardsRepository)
      : super(SubjectOverviewSelectionInitial()) {
    on<SubjectOverviewSelectionToggleSelectMode>(_toggleSelectMode);
    on<SubjectOverviewSelectionChange>(_change);
    on<SubjectOverviewSelectionDeleteSelectedCards>(_deleteCards);
    on<SubjectOverviewSelectionMoveSelectedCards>(_moveSelectedCards);
    on<SubjectOverviewDraggingChange>(_toggleDragging);
  }

  final List<Card> cardsSelected = List.empty(growable: true);
  final CardsRepository _cardsRepository;
  bool isInDragging = false;
  bool isInSelectMode = false;

  FutureOr<void> _toggleSelectMode(
    SubjectOverviewSelectionToggleSelectMode event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    if (event.inSelectMode) {
      isInSelectMode = true;
      emit(SubjectOverviewSelectionModeOn());
    } else {
      isInSelectMode = false;
      cardsSelected.clear();
      emit(SubjectOverviewSelectionModeOff());
    }
  }

  FutureOr<void> _change(
    SubjectOverviewSelectionChange event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    if (event.addCard && !cardsSelected.contains(event.card)) {
      cardsSelected.add(event.card);
    } else if (!event.addCard) {
      cardsSelected.remove(event.card);

      if (cardsSelected.isEmpty && state is SubjectOverviewSelectionModeOn) {
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

    // emit(SubjectOverviewSelectionModeOff());
  }

  Future<FutureOr<void>> _moveSelectedCards(
      SubjectOverviewSelectionMoveSelectedCards event,
      Emitter<SubjectOverviewSelectionState> emit) async {
    cardsSelected.removeWhere((element) => element.parentId == event.parentId);
    await _cardsRepository.moveCards(cardsSelected, event.parentId);
    cardsSelected.clear();
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
}
