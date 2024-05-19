part of 'subject_bloc.dart';

sealed class SubjectState extends Equatable {
  const SubjectState();

  @override
  List<Object> get props => [];
}

final class SubjectLoading extends SubjectState {}

final class SubjectError extends SubjectState {
  final String errorMessage;

  SubjectError({required this.errorMessage});
}

final class SubjectSuccess extends SubjectState {
  final List<String> ids;

  SubjectSuccess({required this.ids});
  @override
  List<Object> get props => ids;
}
