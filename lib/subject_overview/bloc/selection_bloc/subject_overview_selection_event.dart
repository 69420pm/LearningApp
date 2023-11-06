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
    extends SubjectOverviewSelectionEvent {
  //null if in selectMode and hole Selection should be deleted
  String? softSelectedFile;
  SubjectOverviewSelectionDeleteSelectedFiles({
    this.softSelectedFile,
  });
}

class SubjectOverviewSelectionMoveSelection
    extends SubjectOverviewSelectionEvent {
  String parentId;
  SubjectOverviewSelectionMoveSelection({
    required this.parentId,
  });
}

class SubjectOverviewDraggingChange extends SubjectOverviewSelectionEvent {
  bool inDragg;
  String draggedFileUID;

  SubjectOverviewDraggingChange({
    required this.inDragg,
    required this.draggedFileUID,
  });
}

class SubjectOverviewGetSelectedCards extends SubjectOverviewSelectionEvent {}

class SubjectOverviewSetSoftSelectFile extends SubjectOverviewSelectionEvent {
  String fileUID;
  SubjectOverviewSetSoftSelectFile({
    required this.fileUID,
  });
}

class SubjectOverviewSetHoveredFolder extends SubjectOverviewSelectionEvent {
  String folderUID;
  SubjectOverviewSetHoveredFolder({
    required this.folderUID,
  });
}
