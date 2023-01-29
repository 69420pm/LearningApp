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

class FolderListTileMoveCard extends FolderListTileEvent {
  Card card;
  String newParentId;
  FolderListTileMoveCard({
    required this.card,
    required this.newParentId,
  });
}

class FolderListTileDEBUGAddCard extends FolderListTileEvent {
  Card card;
  FolderListTileDEBUGAddCard({
    required this.card,
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

class FolderListTileMoveFolder extends FolderListTileEvent {
  Folder folder;
  String newParentId;
  FolderListTileMoveFolder({
    required this.folder,
    required this.newParentId,
  });
}