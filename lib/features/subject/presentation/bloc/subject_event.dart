part of 'subject_bloc.dart';

sealed class SubjectEvent extends Equatable {
  const SubjectEvent();

  @override
  List<Object> get props => [];
}

class SubjectCreateFolder extends SubjectEvent {
  final String name;

  SubjectCreateFolder({required this.name});
}

class SubjectCreateCard extends SubjectEvent {
  SubjectCreateCard();
}

class SubjectMoveFiles extends SubjectEvent {
  final String parentId;
  final List<String> fileIds;
  const SubjectMoveFiles({
    required this.parentId,
    required this.fileIds,
  });
}
