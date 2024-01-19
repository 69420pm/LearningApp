// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_subject_cubit.dart';

class EditSubjectState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditSubjectInitial extends EditSubjectState {}

class EditSubjectLoading extends EditSubjectState {}

class EditSubjectSuccess extends EditSubjectState {
  Subject subject;
  EditSubjectSuccess({
    required this.subject,
  });
  @override
  List<Object?> get props => [subject];
}

class EditSubjectUpdateWeekdays extends EditSubjectState {
  List<bool> selectedDays;
  EditSubjectUpdateWeekdays({
    required this.selectedDays,
  });
  @override
  List<Object?> get props => [selectedDays];
}

class EditSubjectClassTestChanged extends EditSubjectState {
  List<ClassTest> classTests;
  EditSubjectClassTestChanged({
    required this.classTests,
  });
  @override
  List<Object?> get props => [
        classTests
      ];
}

class EditSubjectFailure extends EditSubjectState {
  EditSubjectFailure({
    required this.errorMessage,
  });
  String errorMessage;
}
