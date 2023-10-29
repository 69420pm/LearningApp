// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'folder_list_tile_bloc.dart';

abstract class FolderListTileEvent {}

// class FolderListTileGetChildren extends FolderListTileEvent {
//   Folder folder;
//   FolderListTileGetChildren({
//     required this.folder,
//   });
// }

class FolderListTileAddFolder extends FolderListTileEvent {
  Folder folder;
  String newParentId;
  FolderListTileAddFolder({required this.folder, required this.newParentId});
}

class FolderListTileUpdate extends FolderListTileEvent {
  String id;
  FolderListTileUpdate({required this.id});
}

class FolderListTileClearHovers extends FolderListTileEvent {
  FolderListTileClearHovers();
}

class FolderListTileChangeFolderName extends FolderListTileEvent {
  Folder folder;
  String newName;
  FolderListTileChangeFolderName({
    required this.folder,
    required this.newName,
  });
}
