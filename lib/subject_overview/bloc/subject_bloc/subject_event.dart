// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'subject_bloc.dart';

abstract class SubjectEvent {}

class SubjectSaveSubject extends SubjectEvent {
  SubjectSaveSubject(this.newSubject);

  Subject newSubject;
}

class SubjectUpdateFoldersCards extends SubjectEvent {
  SubjectUpdateFoldersCards();
}
// class EditSubjectCardSubscriptionRequested extends EditSubjectEvent {
//   EditSubjectCardSubscriptionRequested(this.currentSubjectId);

//   String currentSubjectId;
// }

// class EditSubjectFolderSubscriptionRequested extends EditSubjectEvent {
//   EditSubjectFolderSubscriptionRequested(this.currentSubjectId);

//   String currentSubjectId;
// }

class SubjectAddFolder extends SubjectEvent {
  SubjectAddFolder({required this.name, required this.parentId, this.folderId});
  String name;
  String parentId;
  String? folderId;
}

class SubjectAddCard extends SubjectEvent {
  String name;
  String parentId;
  SubjectAddCard({
    required this.name,
    required this.parentId,
  });
}

class SubjectGetChildrenById extends SubjectEvent {
  String id;
  SubjectGetChildrenById({
    required this.id,
  });
}

class SubjectCloseStreamById extends SubjectEvent {
  String id;
  SubjectCloseStreamById({
    required this.id,
  });
}

class SubjectSetFileParent extends SubjectEvent {
  String parentId;
  String fileUID;

  SubjectSetFileParent({
    required this.parentId,
    required this.fileUID,
  });
}
