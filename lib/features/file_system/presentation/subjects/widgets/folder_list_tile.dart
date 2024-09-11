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
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_hover_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/subject_bloc.dart';

class FolderListTile extends StatelessWidget implements FileListTile {
  final Folder folder;
  final void Function() onTap;
  final bool isSelected;
  final bool isHovered;
  const FolderListTile({
    super.key,
    required this.folder,
    required this.onTap,
    required this.isSelected,
    required this.isHovered,
  });
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onLeave: (details) => context.read<SubjectHoverCubit>().changeHover(""),
      onMove: (details) => context
          .read<SubjectHoverCubit>()
          .changeHover(folder.id), //context.read<FolderBloc>(),
      // onLeave: (data) => context.read<SubjectHoverCubit>().changeHover(""),
      onAcceptWithDetails: (DragTargetDetails<FileDragDetails> details) {
        if (!context.read<SubjectSelectionCubit>().inSelectionMode &&
            details.data.parentId == folder.id) {
          //select file
          context
              .read<SubjectSelectionCubit>()
              .changeSelection(details.data.fileId);
        } else {
          //move hole selection to this folder
          List<String> selectedIds = List<String>.from(
              context.read<SubjectSelectionCubit>().selectedIds);

          if (!selectedIds.contains(details.data.fileId)) {
            selectedIds.add(details.data.fileId);
          }

          context
              .read<SubjectBloc>()
              .add(SubjectMoveFiles(parentId: folder.id, fileIds: selectedIds));
        }
      },
      builder: (BuildContext context, List<Object?> candidateData,
          List<dynamic> rejectedData) {
        return GestureDetector(
          onTap: onTap,
          child: UIExpansionTile(
            title: folder.id,
            backgroundColor: isHovered
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
