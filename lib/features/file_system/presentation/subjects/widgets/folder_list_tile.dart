// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_expansion_tilee.dart';
import 'package:learning_app/features/file_system/domain/entities/folder.dart';
import 'package:learning_app/features/file_system/presentation/subjects/bloc/folder_bloc.dart';

import 'package:learning_app/features/file_system/presentation/subjects/interfaces/file_list_tile.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/folder_content.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/list_tile_wrapper.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';

class FolderListTile extends StatelessWidget implements FileListTile {
  final Folder folder;
  final void Function() onTap;
  FolderListTile({
    super.key,
    required this.folder,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onAcceptWithDetails: (DragTargetDetails<FileDragDetails> details) {
        context.read<FolderBloc>().add(
              FolderMoveFile(parentId: folder.id, fileId: details.data.fileId),
            );
        if (folder.id != details.data.parentId) {
          context
              .read<SubjectSelectionCubit>()
              .deselectListTile(details.data.fileId);
        }
      },
      builder: (
        BuildContext context,
        List<Object?> candidateData,
        List<dynamic> rejectedData,
      ) {
        return UIExpansionTilee(
          title: folder.name,
          onTap: onTap,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FolderContent(parentId: folder.id),
            ),
          ],
        );
      },
    );
  }
}
