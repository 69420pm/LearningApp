import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_bloc/subject_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
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
    // context
    //     .read<FolderListTileBloc>()
    //     .add(FolderListTileGetChildrenById(id: widget.folder.uid));

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
                setState(() {
                  context.read<SubjectOverviewSelectionBloc>().add(
                        SubjectOverviewFolderSelectionChange(
                            folder: widget.folder),
                      );
                });
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
                setState(() {
                  context.read<SubjectOverviewSelectionBloc>().add(
                        SubjectOverviewFolderSelectionChange(
                            folder: widget.folder),
                      );
                });
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
                        .add(FolderListTileUpdate(id: widget.folder.uid));
                  }
                },
                onLeave: (data) {
                  if (isHovered == true) {
                    isHovered = false;
                    context
                        .read<FolderListTileBloc>()
                        .add(FolderListTileUpdate(id: widget.folder.uid));
                  }
                },
                onAccept: (data) {
                  if (data is Folder) {
                    // if (data.parentId == folder.id) return;
                    // context.read<SubjectBloc>().add(
                    //       SubjectSetFolderParent(
                    //         folder: data,
                    //         parentId: folder.uid,
                    //       ),
                    //     );
                  } else if (data is Card) {
                    // if (data.parentId != widget.folder.uid) {
                    //   if (context.read<SubjectOverviewSelectionBloc>().state
                    //       is SubjectOverviewSelectionMultiDragging) {
                    //     context.read<SubjectOverviewSelectionBloc>().add(
                    //           SubjectOverviewSelectionMoveSelectedCards(
                    //             parentId: widget.folder.uid,
                    //           ),
                    //         );
                    //   } else {
                    //     context.read<SubjectBloc>().add(
                    //           SubjectSetCardParent(
                    //             card: data,
                    //             parentId: widget.folder.uid,
                    //           ),
                    //         );
                    //   }
                    // } else if (context
                    //     .read<SubjectOverviewSelectionBloc>()
                    //     .isInSelectMode) {
                    //   context.read<SubjectOverviewSelectionBloc>().add(
                    //         SubjectOverviewSelectionMoveSelectedCards(
                    //           parentId: widget.folder.uid,
                    //         ),
                    //       );
                    // } else {
                    //   context.read<SubjectOverviewSelectionBloc>().add(
                    //         SubjectOverviewSelectionToggleSelectMode(
                    //           inSelectMode: true,
                    //         ),
                    //       );
                    //   context.read<SubjectOverviewSelectionBloc>().add(
                    //         SubjectOverviewCardSelectionChange(
                    //           card: data,
                    //           parentFolder: widget.folder,
                    //         ),
                    //       );
                    // }
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  // return ValueListenableBuilder(
                  //     valueListenable: context
                  //         .read<FolderListTileBloc>()
                  //         .cardsRepository
                  //         .getChildrenById(folder.uid),
                  //     builder: ((context, value, child) {
                  //       final children = value;
                  //       final folders = <Folder>[];
                  //       final cards = <Card>[];
                  //       value.forEach(
                  //         (element) {
                  //           if (element is Folder) {
                  //             folders.add(element);
                  //           } else if (element is Card) {
                  //             cards.add(element);
                  //           }
                  //         },
                  //       );
                  //       return CustomScrollView(
                  //         shrinkWrap: true,
                  //         slivers: [
                  //           SliverList(
                  //             delegate: SliverChildBuilderDelegate(
                  //                 childCount: folders.length,
                  //                 (context, index) {
                  //               // return FolderListTileView(
                  //               //     folder: folders[index]);
                  //             }),
                  //           ),
                  //           SliverList(
                  //             delegate: SliverChildBuilderDelegate(
                  //                 childCount: cards.length,
                  //                 (context, index) {
                  //               // return SubjectListTile(
                  //               //    subject: subjects[index]); 
                  //             }),
                  //           ),
                  //         ],
                  //       );
                  //     }));
                  return BlocBuilder<FolderListTileBloc, FolderListTileState>(
                    buildWhen: (previous, current) {
                      if (current is FolderListTileRetrieveChildren &&
                          current.senderId == widget.folder.uid) {
                        isHovered = false;

                        return true;
                      } else if (current is FolderListTileUpdateOnHover) {
                        if (current.id == widget.folder.uid) return true;
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
                          state.senderId == widget.folder.uid) {
                        childListTiles = {
                          ...childListTiles,
                          ...state.childrenStream
                        };
                        for (final element in state.removedWidgets) {
                          if (childListTiles.containsKey(element.id)) {
                            childListTiles.remove(element.id);
                          }
                        }
                        Map<Card, bool> cards = {};
                        Map<Folder, bool> folders = {};

                        childListTiles.forEach((key, value) {
                          if (value is CardListTile) {
                            cards.addAll({value.card: false});
                          } else if (value is FolderListTileParent) {
                            folders.addAll({value.folder: false});
                          }
                        });

                        context.read<SubjectOverviewSelectionBloc>().add(
                              SubjectOverviewUpdateFolderTable(
                                  folderId: widget.folder.uid,
                                  cards: cards,
                                  folder: folders),
                            );
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
