// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_subject_cubit.dart';

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
