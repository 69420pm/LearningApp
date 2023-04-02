// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'subject_overview_bloc.dart';

abstract class EditSubjectState extends Equatable{}

class EditSubjectInitial extends EditSubjectState {
  @override
  List<Object?> get props => [];
}

class EditSubjectLoading extends EditSubjectState {
  @override
  List<Object?> get props => [];
}

class EditSubjectSuccess extends EditSubjectState {
  @override
  List<Object?> get props => [];
}

class EditSubjectFailure extends EditSubjectState {
  EditSubjectFailure({
    required this.errorMessage,
  });
  final String errorMessage;
  
  @override
  List<Object?> get props => [errorMessage];
}

class EditSubjectFoldersCardsFetchingSuccess extends EditSubjectState {
  @override
  List<Object?> get props => [];
}

class EditSubjectRetrieveChildren extends EditSubjectState {
  final Map<String, Widget> childrenStream;
  final List<Removed> removedWidgets;
  EditSubjectRetrieveChildren({
    required this.childrenStream,
    required this.removedWidgets,
  });
  
  @override
  List<Object?> get props => [childrenStream, removedWidgets];

}
