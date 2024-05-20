// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'folder_bloc.dart';

sealed class FolderEvent extends Equatable {
  const FolderEvent();

  @override
  List<Object> get props => [];
}

class FolderWatchChildrenIds extends FolderEvent {
  final String parentId;
  const FolderWatchChildrenIds({
    required this.parentId,
  });
}

class FolderMoveFile extends FolderEvent {
  final String parentId;
  final String fileUID;
  const FolderMoveFile({
    required this.parentId,
    required this.fileUID,
  });
}
