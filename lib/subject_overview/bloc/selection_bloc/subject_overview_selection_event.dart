part of 'subject_overview_selection_bloc.dart';

@immutable
abstract class SubjectOverviewSelectionEvent {}

class SubjectOverviewSelectionToggleSelectMode
    extends SubjectOverviewSelectionEvent {
  bool inSelectMode;
  SubjectOverviewSelectionToggleSelectMode({
    required this.inSelectMode,
  });
}
