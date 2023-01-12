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

class EditSubjectFoldersCardsFetchingSuccess extends EditSubjectState {}

class EditSubjectRetrieveChildren extends EditSubjectState {
  Map<String, Widget> childrenStream;
  List<Removed> removedWidgets;
  EditSubjectRetrieveChildren({
    required this.childrenStream,
    required this.removedWidgets,
  });
}
