// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'subject_bloc.dart';

abstract class SubjectState extends Equatable{}

class SubjectInitial extends SubjectState {
  @override
  List<Object?> get props => [];
}

class SubjectLoading extends SubjectState {
  @override
  List<Object?> get props => [];
}

class SubjectSuccess extends SubjectState {
  @override
  List<Object?> get props => [];
}

class SubjectFailure extends SubjectState {
  SubjectFailure({
    required this.errorMessage,
  });
  final String errorMessage;
  
  @override
  List<Object?> get props => [errorMessage];
}

class SubjectFoldersCardsFetchingSuccess extends SubjectState {
  @override
  List<Object?> get props => [];
}

class SubjectRetrieveChildren extends SubjectState {
  final Map<String, Widget> childrenStream;
  final List<Removed> removedWidgets;
  SubjectRetrieveChildren({
    required this.childrenStream,
    required this.removedWidgets,
  });
  
  @override
  List<Object?> get props => [childrenStream, removedWidgets];

}
