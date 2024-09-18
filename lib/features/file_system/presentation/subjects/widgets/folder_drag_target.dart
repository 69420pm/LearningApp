import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/list_tile_wrapper.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_hover_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/subject_bloc.dart';

class FolderDragTarget extends StatelessWidget {
  const FolderDragTarget(
      {super.key, required this.folderId, required this.child});

  final String folderId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragTarget<FileDragDetails>(
        onLeave: (details) =>
            context.read<SubjectHoverCubit>().changeHover("", ""),
        onMove: (details) => context
            .read<SubjectHoverCubit>()
            .changeHover(folderId, details.data.fileId),
        onAcceptWithDetails: (DragTargetDetails<FileDragDetails> details) {
          if (!context.read<SubjectSelectionCubit>().inSelectionMode &&
              details.data.parentId == folderId) {
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

            context.read<SubjectBloc>().add(
                SubjectMoveFiles(parentId: folderId, fileIds: selectedIds));
          }
        },
        builder: (BuildContext context, List<Object?> candidateData,
            List<dynamic> rejectedData) {
          return child;
        });
  }
}
