import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_bloc/subject_bloc.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile_view.dart';
import 'package:learning_app/subject_overview/view/inactive_list_tile.dart';
import 'package:learning_app/subject_overview/view/multi_drag_indicator.dart';
import 'package:ui_components/ui_components.dart';

class FolderListTileParent extends StatefulWidget {
  FolderListTileParent({
    super.key,
    required this.folder,
    // required this.cardsRepository,
  });

  final Folder folder;

  @override
  State<FolderListTileParent> createState() => _FolderListTileParentState();
}

class _FolderListTileParentState extends State<FolderListTileParent> {
  // final CardsRepository cardsRepository;
  bool isHovered = false;

  Map<String, Widget> childListTiles = <String, Widget>{};

  @override
  Widget build(BuildContext context) {
    context
        .read<FolderListTileBloc>()
        .add(FolderListTileGetChildrenById(id: widget.folder.id));

    void selectCard(BuildContext context, Card card, bool selected) {
      context.read<SubjectOverviewSelectionBloc>().add(
          SubjectOverviewChangeSelectionInFolderTable(
              folderId: widget.folder.id, select: selected));
      context.read<SubjectOverviewSelectionBloc>().add(
            SubjectOverviewCardSelectionChange(
              card: card,
            ),
          );
    }

    void selectFolder(BuildContext context, Folder folder, bool selected) {
      context.read<SubjectOverviewSelectionBloc>().add(
          SubjectOverviewChangeSelectionInFolderTable(
              folderId: folder.parentId, select: selected));
      setState(() {
        context
            .read<SubjectOverviewSelectionBloc>()
            .add(SubjectOverviewFolderSelectionChange(folder: folder));
      });
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: UIConstants.defaultSize,
      ),
      child: BlocBuilder<SubjectOverviewSelectionBloc,
          SubjectOverviewSelectionState>(
        builder: (context, state) {
          final isSoftSelected = widget.folder ==
              context.read<SubjectOverviewSelectionBloc>().folderSoftSelected;

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (state is! SubjectOverviewSelectionModeOn) {
                context.read<SubjectOverviewSelectionBloc>().add(
                      SubjectOverviewSetSoftSelectFolder(
                        folder: isSoftSelected ? null : widget.folder,
                      ),
                    );
              } else {
                selectFolder(
                    context,
                    widget.folder,
                    !context
                        .read<SubjectOverviewSelectionBloc>()
                        .foldersSelected
                        .contains(widget.folder));
              }
            },
            child: LongPressDraggable<Folder>(
              data: widget.folder,
              feedback: MultiDragIndicator(
                firstFolderName: [widget.folder.name],
                folderAmount: 1,
              ),
              onDragEnd: (details) {
                isHovered = false;
                context
                    .read<FolderListTileBloc>()
                    .add(FolderListTileClearHovers());
              },
              onDraggableCanceled: (_, __) {
                context.read<SubjectOverviewSelectionBloc>().add(
                      SubjectOverviewSelectionToggleSelectMode(
                        inSelectMode: true,
                      ),
                    );
                selectFolder(
                  context,
                  widget.folder,
                  context
                      .read<SubjectOverviewSelectionBloc>()
                      .foldersSelected
                      .contains(widget.folder),
                );
              },
              maxSimultaneousDrags:
                  state is SubjectOverviewSelectionModeOn ? 0 : 1,
              childWhenDragging: const InactiveListTile(),
              child: DragTarget(
                onMove: (details) {
                  if (isHovered == false) {
                    isHovered = true;
                    context
                        .read<FolderListTileBloc>()
                        .add(FolderListTileUpdate(id: widget.folder.id));
                  }
                },
                onLeave: (data) {
                  if (isHovered == true) {
                    isHovered = false;
                    context
                        .read<FolderListTileBloc>()
                        .add(FolderListTileUpdate(id: widget.folder.id));
                  }
                },
                onAccept: (data) {
                  if (data is Folder) {
                    if (data.parentId == widget.folder.id) {
                      if (!context
                          .read<SubjectOverviewSelectionBloc>()
                          .isInSelectMode) {
                        context.read<SubjectOverviewSelectionBloc>().add(
                              SubjectOverviewSelectionToggleSelectMode(
                                inSelectMode: true,
                              ),
                            );
                        selectFolder(
                          context,
                          data,
                          true,
                        );
                      }
                    } else {
                      context.read<SubjectBloc>().add(
                            SubjectSetFolderParent(
                              folder: data,
                              parentId: widget.folder.id,
                            ),
                          );
                    }
                  } else if (data is Card) {
                    if (data.parentId != widget.folder.id) {
                      if (context.read<SubjectOverviewSelectionBloc>().state
                          is SubjectOverviewSelectionMultiDragging) {
                        context.read<SubjectOverviewSelectionBloc>().add(
                              SubjectOverviewSelectionMoveSelectedCards(
                                parentId: widget.folder.id,
                              ),
                            );
                      } else {
                        context.read<SubjectBloc>().add(
                              SubjectSetCardParent(
                                card: data,
                                parentId: widget.folder.id,
                              ),
                            );
                      }
                    } else if (context
                        .read<SubjectOverviewSelectionBloc>()
                        .isInSelectMode) {
                      context.read<SubjectOverviewSelectionBloc>().add(
                            SubjectOverviewSelectionMoveSelectedCards(
                              parentId: widget.folder.id,
                            ),
                          );
                    } else {
                      context.read<SubjectOverviewSelectionBloc>().add(
                            SubjectOverviewSelectionToggleSelectMode(
                              inSelectMode: true,
                            ),
                          );
                      selectCard(context, data, true);
                    }
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  return BlocBuilder<FolderListTileBloc, FolderListTileState>(
                    buildWhen: (previous, current) {
                      if (current is FolderListTileRetrieveChildren &&
                          current.senderId == widget.folder.id) {
                        isHovered = false;

                        return true;
                      } else if (current is FolderListTileUpdateOnHover) {
                        if (current.id == widget.folder.id) return true;
                      } else if (current is FolderListTileToClearHover) {
                        if (isHovered == true) {
                          isHovered = false;
                          return true;
                        }
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (state is FolderListTileRetrieveChildren &&
                          state.senderId == widget.folder.id) {
                        childListTiles = {
                          ...childListTiles,
                          ...state.childrenStream
                        };
                        for (final element in state.removedWidgets) {
                          if (childListTiles.containsKey(element.id)) {
                            childListTiles.remove(element.id);
                          }
                        }
                        context.read<SubjectOverviewSelectionBloc>().add(
                            SubjectOverviewUpdateFolderTable(
                                folderId: widget.folder.id,
                                numberOfChildren: childListTiles.length));
                      }

                      return BlocBuilder<SubjectOverviewSelectionBloc,
                          SubjectOverviewSelectionState>(
                        builder: (context, state) {
                          return FolderListTileView(
                            isHoverd: isHovered,
                            inSelectionMode:
                                state is SubjectOverviewSelectionModeOn,
                            folder: widget.folder,
                            childListTiles: childListTiles,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
