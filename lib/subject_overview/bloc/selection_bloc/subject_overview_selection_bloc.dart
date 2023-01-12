import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;

part 'subject_overview_selection_event.dart';
part 'subject_overview_selection_state.dart';

class SubjectOverviewSelectionBloc
    extends Bloc<SubjectOverviewSelectionEvent, SubjectOverviewSelectionState> {
  SubjectOverviewSelectionBloc() : super(SubjectOverviewSelectionInitial()) {
    on<SubjectOverviewSelectionToggleSelectMode>(_toggleSelectMode);
    on<SubjectOverviewSelectionChange>(_change);
  }

  final List<Card> _cardsSelected = List.empty(growable: true);

  FutureOr<void> _toggleSelectMode(
      SubjectOverviewSelectionToggleSelectMode event,
      Emitter<SubjectOverviewSelectionState> emit) {
    if (event.inSelectMode) {
      emit(SubjectOverviewSelectionModeOn());
    } else {
      emit(SubjectOverviewSelectionModeOff());
    }
  }

  FutureOr<void> _change(SubjectOverviewSelectionChange event,
      Emitter<SubjectOverviewSelectionState> emit) {
    if (event.addCard) {
      _cardsSelected.add(event.card);
    } else {
      _cardsSelected.remove(event.card);

      if (_cardsSelected.isEmpty && state is SubjectOverviewSelectionModeOn) {
        emit(SubjectOverviewSelectionModeOff());
      }
    }
  }
}
