// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/file_system/domain/entities/card.dart';
import 'package:learning_app/features/file_system/domain/entities/folder.dart';
import 'package:learning_app/features/file_system/presentation/subjects/bloc/folder_bloc.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/card_list_tile.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/folder_list_tile.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_hover_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';

/// wraps Folder and Card list tiles and updates them listening, to their
/// watch stream accordingly
class ListTileWrapper extends StatelessWidget {
  final String id;
  const ListTileWrapper({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    void _onTileClicked() {
      if (context.read<SubjectSelectionCubit>().inSelectionMode) {
        context.read<SubjectSelectionCubit>().changeSelection(id);
      }
    }

    return LongPressDraggable(
      data: FileDragDetails(
        fileId: id,
        parentId: context.read<FolderBloc>().parentId,
      ),
      feedback: Container(
        color: Colors.red,
        height: 20,
        width: 100,
      ),
      childWhenDragging: Container(
        color: Colors.green,
        height: 20,
        width: 100,
      ),
      onDragEnd: (details) => context.read<SubjectHoverCubit>().changeHover(""),
      onDragStarted: () {
        print(context.read<FolderBloc>().parentId);
        context
            .read<SubjectHoverCubit>()
            .changeHover(context.read<FolderBloc>().parentId);
      },
      child: BlocBuilder<SubjectSelectionCubit, SubjectSelectionState>(
        buildWhen: (previous, current) =>
            current is SubjectSelectionSelectionChanged &&
            current.changedIds.contains(id),
        builder: (context, state) {
          bool selected = (state as SubjectSelectionSelectionChanged)
              .selectedIds
              .contains(id);

          return BlocBuilder<SubjectHoverCubit, SubjectHoverState>(
            buildWhen: (previous, current) =>
                (previous is SubjectHoverChanged && previous.newId == id) ||
                (current is SubjectHoverChanged && current.newId == id),
            builder: (context, state) {
              bool hovered = state is SubjectHoverChanged && state.newId == id;
              return StreamBuilder(
                stream: context.read<FolderBloc>().subscribedStreams[id],
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (!snapshot.data!.deleted &&
                        snapshot.data!.value is Folder) {
                      return FolderListTile(
                        folder: snapshot.data!.value as Folder,
                        isSelected: selected,
                        onTap: _onTileClicked,
                        isHovered: hovered,
                      );
                    } else if (!snapshot.data!.deleted &&
                        snapshot.data!.value is Card) {
                      return CardListTile(
                        card: snapshot.data!.value as Card,
                        isSelected: selected,
                        onTap: _onTileClicked,
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class FileDragDetails {
  final String fileId;
  final String parentId;

  FileDragDetails({required this.fileId, required this.parentId});
}
