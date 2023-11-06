part of 'subject_overview_selection_bloc.dart';

@immutable
abstract class SubjectOverviewSelectionState {}

class SubjectOverviewSelectionInitial extends SubjectOverviewSelectionState {}

class SubjectOverviewSelectionModeOn extends SubjectOverviewSelectionState {}

class SubjectOverviewSelectionModeOff extends SubjectOverviewSelectionState {}

class SubjectOverviewSoftSelectionModeOn
    extends SubjectOverviewSelectionState {}

class SubjectOverviewSelectionMultiDraggingChange
    extends SubjectOverviewSelectionState {}

class SubjectOverviewSelectionUpdateHover
    extends SubjectOverviewSelectionState {}
