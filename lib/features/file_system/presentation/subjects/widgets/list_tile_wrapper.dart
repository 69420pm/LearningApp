// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/file_system/domain/entities/card.dart';
import 'package:learning_app/features/file_system/domain/entities/folder.dart';
import 'package:learning_app/features/file_system/presentation/subjects/bloc/folder_bloc.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/card_list_tile.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/folder_list_tile.dart';
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
    return LongPressDraggable(
      data: FileDragDetails(
        fileId: id,
        parentId: context.read<FolderBloc>().parentId,
      ),
      feedback: Container(
        color: Colors.red,
        height: 50,
        width: 100,
      ),
      childWhenDragging: Container(
        color: Colors.green,
        height: 50,
        width: 100,
      ),
      onDragStarted: () {
        context.read<SubjectSelectionCubit>().selectListTile(id);
      },
      // this blocBuilder only provides the state to the children (folder and
      // cards) to handle their on tap events, it never explicitly rebuilds
      child: BlocBuilder<SubjectSelectionCubit, SubjectSelectionState>(
        buildWhen: (previous, current) {
          return false;
        },
        builder: (context, state) {
          return Stack(
            children: [
              // this blocBuilder rebuilds the selection frame for the children
              // to display the selection state, it doesn't rebuild anything else
              BlocBuilder<SubjectSelectionCubit, SubjectSelectionState>(
                buildWhen: (previous, current) {
                  if (current is SubjectSelectionSelectionChanged) {
                    if (current.selectedIds.contains(id) ||
                        current.previouslySelectedIds.contains(id)) {
                      return true;
                    }
                  }
                  return false;
                },
                builder: (context, state) {
                  bool selected = false;
                  if (state is SubjectSelectionSelectionChanged) {
                    if (state.selectedIds.contains(id)) {
                      selected = true;
                    }
                  }
                  return Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selected ? Colors.green : Colors.transparent,
                          ),
                        ),
                      ));
                },
              ),
              StreamBuilder(
                stream: context.read<FolderBloc>().subscribedStreams[id],
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (!snapshot.data!.deleted &&
                        snapshot.data!.value is Folder) {
                      return FolderListTile(
                        folder: snapshot.data!.value as Folder,
                        onTap: () {
                          if (state is SubjectSelectionSelectionChanged &&
                              state.selectedIds.contains(id)) {
                            context
                                .read<SubjectSelectionCubit>()
                                .deselectListTile(id);
                          } else if (context
                              .read<SubjectSelectionCubit>()
                              .inSelectionMode) {
                            context
                                .read<SubjectSelectionCubit>()
                                .selectListTile(id);
                          }
                        },
                      );
                    } else if (!snapshot.data!.deleted &&
                        snapshot.data!.value is Card) {
                      return CardListTile(
                          card: snapshot.data!.value as Card,
                          onTap: () {
                            if (state is SubjectSelectionSelectionChanged) {
                              if (state.selectedIds.contains(id)) {
                                context
                                    .read<SubjectSelectionCubit>()
                                    .deselectListTile(id);
                              } else if (context
                                  .read<SubjectSelectionCubit>()
                                  .inSelectionMode) {
                                context
                                    .read<SubjectSelectionCubit>()
                                    .selectListTile(id);
                              }
                            }
                          });
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
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
