// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class SubjectOverviewCardSelectionChange extends SubjectOverviewSelectionEvent {
  String cardUID;
  SubjectOverviewCardSelectionChange({
    required this.cardUID,
  });
}

class SubjectOverviewFolderSelectionChange
    extends SubjectOverviewSelectionEvent {
  String folderUID;
  SubjectOverviewFolderSelectionChange({
    required this.folderUID,
  });
}

class SubjectOverviewSelectionDeleteSelectedFiles
    extends SubjectOverviewSelectionEvent {}

class SubjectOverviewSelectionMoveSelectedCards
    extends SubjectOverviewSelectionEvent {
  String parentId;
  SubjectOverviewSelectionMoveSelectedCards({
    required this.parentId,
  });
}

class SubjectOverviewDraggingChange extends SubjectOverviewSelectionEvent {
  bool inDragg;
  SubjectOverviewDraggingChange({
    required this.inDragg,
  });
}

class SubjectOverviewGetSelectedCards extends SubjectOverviewSelectionEvent {}

class SubjectOverviewSetSoftSelectFolder extends SubjectOverviewSelectionEvent {
  String folderUID;
  SubjectOverviewSetSoftSelectFolder({
    required this.folderUID,
  });
}
