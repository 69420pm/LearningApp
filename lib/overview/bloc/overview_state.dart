// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'overview_bloc.dart';

@immutable
abstract class OverviewState {}

class OverviewInitial extends OverviewState {}

class OverviewLoading extends OverviewState {}

class OverviewSuccess extends OverviewState {
  OverviewSuccess({
    required this.subjects,
  });
  List<Subject> subjects;
}

class OverviewFailure extends OverviewState {
  OverviewFailure({
    required this.errorMessage,
  });
  String errorMessage;
}
