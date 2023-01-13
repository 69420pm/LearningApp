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
  }

  final List<Card> _cardsSelected = List.empty(growable: true);
  final CardsRepository _cardsRepository;

  FutureOr<void> _toggleSelectMode(
    SubjectOverviewSelectionToggleSelectMode event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    if (event.inSelectMode) {
      emit(SubjectOverviewSelectionModeOn());
    } else {
      _cardsSelected.clear();
      emit(SubjectOverviewSelectionModeOff());
    }
  }

  FutureOr<void> _change(
    SubjectOverviewSelectionChange event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) {
    if (event.addCard) {
      _cardsSelected.add(event.card);
    } else {
      _cardsSelected.remove(event.card);

      if (_cardsSelected.isEmpty && state is SubjectOverviewSelectionModeOn) {
        emit(SubjectOverviewSelectionModeOff());
      }
    }
  }

  FutureOr<void> _deleteCards(
    SubjectOverviewSelectionDeleteSelectedCards event,
    Emitter<SubjectOverviewSelectionState> emit,
  ) async {
    print(_cardsSelected.map((e) => e.front).toString());
    List<String> ids = [];
    List<String> parentIds = [];
    for (var i = 0; i < _cardsSelected.length; i++) {
        ids.add(_cardsSelected[i].id);
        parentIds.add(_cardsSelected[i].parentId);
    }
    await _cardsRepository.deleteCards(ids, parentIds);

    // emit(SubjectOverviewSelectionModeOff());
  }
}
