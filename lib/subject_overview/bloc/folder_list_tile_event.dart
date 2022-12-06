// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'folder_list_tile_bloc.dart';

abstract class FolderListTileEvent {}

class FolderListTileGetChildrenById extends FolderListTileEvent {
  String id;
  FolderListTileGetChildrenById({
    required this.id,
  });
}
