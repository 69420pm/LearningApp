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
  Map<Folder, bool> folder;
  Map<Card, bool> cards;
  SubjectOverviewUpdateFolderTable({
    required this.folderId,
    required this.folder,
    required this.cards,
  });
}
