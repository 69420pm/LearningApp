// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'subject_overview_bloc.dart';

abstract class EditSubjectEvent {}

class EditSubjectSaveSubject extends EditSubjectEvent {
  EditSubjectSaveSubject(this.newSubject);

  Subject newSubject;
}

class EditSubjectUpdateFoldersCards extends EditSubjectEvent {
  EditSubjectUpdateFoldersCards();
}
// class EditSubjectCardSubscriptionRequested extends EditSubjectEvent {
//   EditSubjectCardSubscriptionRequested(this.currentSubjectId);

//   String currentSubjectId;
// }

// class EditSubjectFolderSubscriptionRequested extends EditSubjectEvent {
//   EditSubjectFolderSubscriptionRequested(this.currentSubjectId);

//   String currentSubjectId;
// }

class EditSubjectAddFolder extends EditSubjectEvent {
  EditSubjectAddFolder({required this.name, required this.parentId});
  String name;
  String parentId;
}

class EditSubjectAddCard extends EditSubjectEvent {
  String front;
  String back;
  String parentId;
  EditSubjectAddCard({
    required this.front,
    required this.back,
    required this.parentId,
  });
}

class EditSubjectGetChildrenById extends EditSubjectEvent {
  String id;
  EditSubjectGetChildrenById({
    required this.id,
  });
}

class EditSubjectCloseStreamById extends EditSubjectEvent {
  String id;
  EditSubjectCloseStreamById({
    required this.id,
  });
}