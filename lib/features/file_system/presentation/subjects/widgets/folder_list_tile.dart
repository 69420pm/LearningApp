// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  const FolderListTile({
    super.key,
    required this.folder,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    bool hovered = false;
    return Stack(
      children: [
        Positioned.fill(
          child: DragTarget(
            onMove: (details) {
              print("move");
              hovered = true;
            },
            onLeave: (data) {
              hovered = false;
            },
            onAcceptWithDetails: (DragTargetDetails<FileDragDetails> details) {
              context.read<FolderBloc>().add(
                    FolderMoveFile(
                      parentId: folder.id,
                      fileId: details.data.fileId,
                    ),
                  );
              if (folder.id != details.data.parentId) {
                context.read<SubjectSelectionCubit>().deselectListTile(
                      details.data.fileId,
                    );
              }
            },
            builder: (
              BuildContext context,
              List<Object?> candidateData,
              List<dynamic> rejectedData,
            ) {
              return Container(
                color: Colors.transparent,
                // decoration: BoxDecoration(
                //   color: Color.fromARGB(20, 255, 0, 0),
                //   border: Border.all(
                //     color: hovered ? Colors.green : Colors.transparent,
                //   ),
                // ),
              );
            },
          ),
        ),
        UIExpansionTilee(
          title: folder.name,
          onTap: onTap,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FolderContent(parentId: folder.id),
            ),
          ],
        ),
      ],
    );

    return DragTarget(
      onMove: (details) {},
      onAcceptWithDetails: (DragTargetDetails<FileDragDetails> details) {
        context.read<FolderBloc>().add(
              FolderMoveFile(parentId: folder.id, fileId: details.data.fileId),
            );
        if (folder.id != details.data.parentId) {
          context.read<SubjectSelectionCubit>().deselectListTile(
                details.data.fileId,
              );
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
