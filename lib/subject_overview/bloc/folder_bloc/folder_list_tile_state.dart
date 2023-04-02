// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'folder_list_tile_bloc.dart';

@immutable
abstract class FolderListTileState extends Equatable {}

class FolderListTileInitial extends FolderListTileState {
  @override
  List<Object?> get props => [];
}

class FolderListTileRetrieveChildren extends FolderListTileState {
  final Map<String, Widget> childrenStream;
  final List<Removed> removedWidgets;
  final String senderId;
  FolderListTileRetrieveChildren(
    {
    required this.senderId,
    required this.childrenStream,
    required this.removedWidgets,
  });

  @override
  List<Object?> get props => [childrenStream, removedWidgets];
}

class FolderListTileLoading extends FolderListTileState {
  @override
  List<Object?> get props => [];
}

class FolderListTileError extends FolderListTileState {
  final String errorMessage;
  FolderListTileError({
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [errorMessage];
}

class FolderListTileSuccess extends FolderListTileState {
  @override
  List<Object?> get props => [];
}
