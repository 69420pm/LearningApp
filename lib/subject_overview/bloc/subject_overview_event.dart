part of 'subject_overview_bloc.dart';

abstract class EditSubjectEvent {}

class EditSubjectSaveSubject extends EditSubjectEvent {
  EditSubjectSaveSubject(this.newSubject);

  Subject newSubject;
}

class EditSubjectCardSubscriptionRequested extends EditSubjectEvent {
  EditSubjectCardSubscriptionRequested(this.currentSubjectId);

  String currentSubjectId;
}

class EditSubjectFolderSubscriptionRequested extends EditSubjectEvent {
  EditSubjectFolderSubscriptionRequested(this.currentSubjectId);

  String currentSubjectId;
}