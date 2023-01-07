import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'subject_overview_selection_event.dart';
part 'subject_overview_selection_state.dart';

class SubjectOverviewSelectionBloc
    extends Bloc<SubjectOverviewSelectionEvent, SubjectOverviewSelectionState> {
  SubjectOverviewSelectionBloc() : super(SubjectOverviewSelectionInitial()) {
    on<SubjectOverviewSelectionToggleSelectMode>(_toggleSelectMode);
  }

  FutureOr<void> _toggleSelectMode(
      SubjectOverviewSelectionToggleSelectMode event,
      Emitter<SubjectOverviewSelectionState> emit) {
    if (event.inSelectMode) {
      emit(SubjectOverviewSelectionModeOn());
    } else {
      emit(SubjectOverviewSelectionModeOff());
    }
  }
}
