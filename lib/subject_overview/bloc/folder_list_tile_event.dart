// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'folder_list_tile_bloc.dart';

abstract class FolderListTileEvent {}

class FolderListTileGetChildrenById extends FolderListTileEvent {
  String id;
  FolderListTileGetChildrenById({
    required this.id,
  });
}

class FolderListTileAddFolder extends FolderListTileEvent {
  Folder folder;
  String newParentId;
  FolderListTileAddFolder({required this.folder, required this.newParentId});
}

class FolderListTileAddCard extends FolderListTileEvent {
  Card card;
  String newParentId;
  FolderListTileAddCard({
    required this.card,
    required this.newParentId,
  });
}

class FolderListTileDeleteFolder extends FolderListTileEvent {
  String id;
  String parentId;
  FolderListTileDeleteFolder({
    required this.id,
    required this.parentId,
  });
}

class FolderLIstTileMoveFolder extends FolderListTileEvent {
  String id;
  String previousParentId;
  String newParentId;
  FolderLIstTileMoveFolder({
    required this.id,
    required this.previousParentId,
    required this.newParentId,
  });
}
