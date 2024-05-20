// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_expansion_tile.dart';
import 'package:learning_app/features/folder_system/domain/entities/file.dart';
import 'package:learning_app/features/folder_system/domain/entities/folder.dart';
import 'package:learning_app/features/folder_system/presentation/subjects/bloc/folder_bloc.dart';

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
    return DragTarget(
      onAcceptWithDetails: (DragTargetDetails<String> details) => context
          .read<FolderBloc>()
          .add(FolderMoveFile(parentId: folder.id, fileId: details.data)),
      builder: (BuildContext context, List<Object?> candidateData,
              List<dynamic> rejectedData) =>
          UIExpansionTile(
        title: folder.name,
        children: [FolderContent(parentId: folder.id)],
      ),
    );
  }
}
