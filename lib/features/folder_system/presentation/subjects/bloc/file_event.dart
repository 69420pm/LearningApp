// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'file_bloc.dart';

sealed class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

class FileWatchChildrenIds extends FileEvent {
  final String parentId;
  FileWatchChildrenIds({
    required this.parentId,
  });
}
