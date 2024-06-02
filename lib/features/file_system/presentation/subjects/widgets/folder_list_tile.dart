// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_expansion_tile.dart';
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
  final bool isSelected;
  const FolderListTile({
    super.key,
    required this.folder,
    required this.onTap,
    required this.isSelected,
  });
  @override
  Widget build(BuildContext context) {
    bool hovered = false;
    return DragTarget(
      onMove: (details) => hovered = true,
      onLeave: (details) => hovered = false,
      onAcceptWithDetails: (DragTargetDetails<FileDragDetails> details) {
        hovered = false;
        if (details.data.parentId == folder.id) {
          context
              .read<SubjectSelectionCubit>()
              .changeSelection(details.data.fileId);
        }
        context.read<FolderBloc>().add(
              FolderMoveFile(parentId: folder.id, fileId: details.data.fileId),
            );
      },
      builder: (BuildContext context, List<Object?> candidateData,
          List<dynamic> rejectedData) {
        return GestureDetector(
          onTap: onTap,
          child: UIExpansionTile(
            title: folder.name,
            backgroundColor: hovered
                ? Colors.grey
                : isSelected
                    ? Colors.green
                    : Colors.black,
            child: FolderContent(parentId: folder.id),
          ),
        );
      },
    );
  }
}
