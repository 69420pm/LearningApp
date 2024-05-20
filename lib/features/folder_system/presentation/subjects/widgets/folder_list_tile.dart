// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:learning_app/features/folder_system/domain/entities/folder.dart';

import 'package:learning_app/features/folder_system/presentation/subjects/interfaces/file_list_tile.dart';
import 'package:learning_app/features/folder_system/presentation/subjects/widgets/folder_content.dart';

class FolderListTile extends StatelessWidget implements FileListTile {
  final Folder folder;
  const FolderListTile({
    super.key,
    required this.folder,
  });
  @override
  Widget build(BuildContext context) {
    print(folder.id);
    return ExpansionTile(
      title: Text(folder.name),
      children: [FolderContent(parentId: folder.id)],
    );
  }
}
