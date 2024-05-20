part of 'subject_bloc.dart';

sealed class SubjectState extends Equatable {
  const SubjectState();
  
  @override
  List<Object> get props => [];
}

final class SubjectInitial extends SubjectState {}
