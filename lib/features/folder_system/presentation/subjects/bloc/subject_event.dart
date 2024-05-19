// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'subject_bloc.dart';

sealed class SubjectEvent extends Equatable {
  const SubjectEvent();

  @override
  List<Object> get props => [];
}

class SubjectWatchChildrenIds extends SubjectEvent {
  final String parentId;
  SubjectWatchChildrenIds({
    required this.parentId,
  });
}

class SubjectCreateFolder extends SubjectEvent {
  final String name;
  SubjectCreateFolder({
    required this.name,
  });
}
