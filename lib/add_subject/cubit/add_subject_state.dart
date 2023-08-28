// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_subject_cubit.dart';

abstract class AddSubjectState {}

class AddSubjectInitial extends AddSubjectState {}

class AddSubjectLoading extends AddSubjectState {}

class AddSubjectSuccess extends AddSubjectState {}

class AddSubjectUpdateWeekdays extends AddSubjectState {
  AddSubjectUpdateWeekdays({
    required this.selectedDays,
  });
  List<bool> selectedDays;
}

class AddSubjectFailure extends AddSubjectState {
  AddSubjectFailure({
    required this.errorMessage,
  });
  String errorMessage;
}
