// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'subject_overview_bloc.dart';

abstract class EditSubjectState {}

class EditSubjectInitial extends EditSubjectState {}

class EditSubjectLoading extends EditSubjectState {}

class EditSubjectSuccess extends EditSubjectState {}

class EditSubjectFailure extends EditSubjectState {
  EditSubjectFailure({
    required this.errorMessage,
  });
  String errorMessage;
}

class EditSubjectCardFetchingLoading extends EditSubjectState {}

class EditSubjectCardFetchingSuccess extends EditSubjectState {
  EditSubjectCardFetchingSuccess({
    required this.cards,
  });
  List<Card> cards;
}

class EditSubjectCardFetchingFailure extends EditSubjectState {
  EditSubjectCardFetchingFailure({
    required this.errorMessage,
  });
  String errorMessage;
}

class EditSubjectFolderFetchingLoading extends EditSubjectState {}

class EditSubjectFolderFetchingSuccess extends EditSubjectState {
  EditSubjectFolderFetchingSuccess({
    required this.subjects,
  });
  List<Subject> subjects;
}

class EditSubjectFolderFetchingFailure extends EditSubjectState {
  EditSubjectFolderFetchingFailure({
    required this.errorMessage,
  });
  String errorMessage;
}
