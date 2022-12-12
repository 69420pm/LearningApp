// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'folder_list_tile_bloc.dart';

@immutable
abstract class FolderListTileState {}

class FolderListTileInitial extends FolderListTileState {}

class FolderListTileRetrieveChildren extends FolderListTileState {
  Map<String, Widget> childrenStream;
  List<Removed> removedWidgets;
  FolderListTileRetrieveChildren({
    required this.childrenStream,
    required this.removedWidgets,
  });
}

class FolderListTileLoading extends FolderListTileState {}

class FolderListTileError extends FolderListTileState {
  String errorMessage;
  FolderListTileError({
    required this.errorMessage,
  });
}

class FolderListTileSuccess extends FolderListTileState{}