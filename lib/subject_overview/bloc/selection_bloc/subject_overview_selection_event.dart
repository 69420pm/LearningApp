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
  Card card;
  SubjectOverviewCardSelectionChange({
    required this.card,
  });
}

class SubjectOverviewFolderSelectionChange
    extends SubjectOverviewSelectionEvent {
  Folder folder;
  SubjectOverviewFolderSelectionChange({
    required this.folder,
  });
}

class SubjectOverviewSelectionDeleteSelectedCards
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
  Folder? folder;
  SubjectOverviewSetSoftSelectFolder({
    required this.folder,
  });
}

class SubjectOverviewUpdateFolderTable extends SubjectOverviewSelectionEvent {
  String folderId;
  int numberOfChildren;
  SubjectOverviewUpdateFolderTable({
    required this.folderId,
    required this.numberOfChildren,
  });
}

class SubjectOverviewChangeSelectionInFolderTable
    extends SubjectOverviewSelectionEvent {
  String folderId;
  bool select;
  SubjectOverviewChangeSelectionInFolderTable({
    required this.folderId,
    required this.select,
  });
}
