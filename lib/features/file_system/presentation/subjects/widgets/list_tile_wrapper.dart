// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/file_system/domain/entities/card.dart';
import 'package:learning_app/features/file_system/domain/entities/folder.dart';
import 'package:learning_app/features/file_system/presentation/subjects/bloc/folder_bloc.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/card_list_tile.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/folder_list_tile.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/inactive_list_tile.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/multi_drag_indicator.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_hover_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';
import 'package:learning_app/injection_container.dart';

/// wraps Folder and Card list tiles and updates them, listening to their
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

    return BlocBuilder<SubjectSelectionCubit, SubjectSelectionState>(
      builder: (context, state) {
        bool selected = (state as SubjectSelectionSelectionChanged)
            .selectedIds
            .contains(id);

        return LongPressDraggable(
          maxSimultaneousDrags:
              context.read<SubjectSelectionCubit>().inSelectionMode
                  ? selected
                      ? 1
                      : 0
                  : 1,
          data: FileDragDetails(
            fileId: id,
            parentId: context.read<FolderBloc>().parentId,
          ),
          feedback: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: BlocProvider.of<SubjectHoverCubit>(context),
              ),
              BlocProvider.value(
                value: BlocProvider.of<FolderBloc>(context),
              ),
              BlocProvider.value(
                value: BlocProvider.of<SubjectSelectionCubit>(context),
              ),
            ],
            child: BlocBuilder<SubjectSelectionCubit, SubjectSelectionState>(
              builder: (context, state) {
                return MultiDragIndicator(
                  fileUIDs: context
                          .read<SubjectSelectionCubit>()
                          .selectedIds
                          .contains(id)
                      ? context.read<SubjectSelectionCubit>().selectedIds
                      : [
                          id,
                          ...context.read<SubjectSelectionCubit>().selectedIds
                        ],
                );
              },
            ),
          ),
          childWhenDragging: const InactiveListTile(),
          onDragEnd: (details) {
            context.read<SubjectHoverCubit>().endDrag();
          },
          onDragStarted: () {
            context
                .read<SubjectHoverCubit>()
                .changeHover(context.read<FolderBloc>().parentId, id);
          },
          child: BlocBuilder<SubjectHoverCubit, SubjectHoverState>(
            builder: (context, state) {
              bool hovered = state is SubjectHoverChanged && state.newId == id;
              return StreamBuilder(
                stream: context.read<FolderBloc>().subscribedStreams[id],
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (selected &&
                        context.read<SubjectHoverCubit>().isDragging) {
                      return const InactiveListTile();
                    } else if (!snapshot.data!.deleted &&
                        snapshot.data!.value is Folder) {
                      return FolderListTile(
                        folder: snapshot.data!.value as Folder,
                        isSelected: selected,
                        onTap: _onTileClicked,
                        isHovered: hovered,
                        changeExtensionState:
                            state is SubjectHoverChanged && state.newId == id,
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
          ),
        );
      },
    );
  }
}

class FileDragDetails {
  final String fileId;
  final String parentId;

  FileDragDetails({required this.fileId, required this.parentId});
}
