part of 'subject_bloc.dart';

sealed class SubjectEvent extends Equatable {
  const SubjectEvent();

  @override
  List<Object> get props => [];
}

class SubjectCreateFolder extends SubjectEvent {
  final String name;

  SubjectCreateFolder({required this.name});
}
