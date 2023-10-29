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

class FolderListTileParent extends StatelessWidget {
  FolderListTileParent({
    super.key,
    required this.folder,
    required this.cardsRepository,
  });

  final Folder folder;
  final CardsRepository cardsRepository;

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    // context
    //     .read<FolderListTileBloc>()
    //     .add(FolderListTileGetChildrenById(id: widget.folder.uid));
    final isSoftSelected = folder.uid ==
        context.read<SubjectOverviewSelectionBloc>().folderUIDSoftSelected;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: UIConstants.defaultSize,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (!context.read<SubjectOverviewSelectionBloc>().isInSelectMode) {
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewSetSoftSelectFolder(
                    folderUID: isSoftSelected ? "" : folder.uid,
                  ),
                );
          } else {
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewFolderSelectionChange(folderUID: folder.uid),
                );
          }
        },
        child: LongPressDraggable<Folder>(
          data: folder,
          feedback: MultiDragIndicator(
            firstFolderName: [folder.name],
            folderAmount: 1,
          ),
          onDragEnd: (details) {
            isHovered = false;
            context.read<FolderListTileBloc>().add(FolderListTileClearHovers());
          },
          onDraggableCanceled: (_, __) {
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewSelectionToggleSelectMode(
                    inSelectMode: true,
                  ),
                );

            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewFolderSelectionChange(folderUID: folder.uid),
                );
          },
          maxSimultaneousDrags:
              context.read<SubjectOverviewSelectionBloc>().isInSelectMode
                  ? 0
                  : 1,
          childWhenDragging: const InactiveListTile(),
          child: DragTarget(
            onMove: (details) {
              if (isHovered == false) {
                isHovered = true;
                context
                    .read<FolderListTileBloc>()
                    .add(FolderListTileUpdate(id: folder.uid));
              }
            },
            onLeave: (data) {
              if (isHovered == true) {
                isHovered = false;
                context
                    .read<FolderListTileBloc>()
                    .add(FolderListTileUpdate(id: folder.uid));
              }
            },
            onAccept: (data) {
              if (data is Folder) {
                if (cardsRepository.getParentIdFromChildId(data.uid) ==
                    folder.uid) return;
                context.read<SubjectBloc>().add(
                      SubjectSetFileParent(
                        fileUID: data.uid,
                        parentId: folder.uid,
                      ),
                    );
              } else if (data is Card) {
                if (cardsRepository.getParentIdFromChildId(data.uid) !=
                    folder.uid) {
                  if (context.read<SubjectOverviewSelectionBloc>().state
                      is SubjectOverviewSelectionMultiDragging) {
                    context.read<SubjectOverviewSelectionBloc>().add(
                          SubjectOverviewSelectionMoveSelection(
                            parentId: folder.uid,
                          ),
                        );
                  } else {
                    context.read<SubjectBloc>().add(
                          SubjectSetFileParent(
                            fileUID: data.uid,
                            parentId: folder.uid,
                          ),
                        );
                  }
                } else if (context
                    .read<SubjectOverviewSelectionBloc>()
                    .isInSelectMode) {
                  context.read<SubjectOverviewSelectionBloc>().add(
                        SubjectOverviewSelectionMoveSelection(
                          parentId: folder.uid,
                        ),
                      );
                } else {
                  context.read<SubjectOverviewSelectionBloc>().add(
                        SubjectOverviewSelectionToggleSelectMode(
                          inSelectMode: true,
                        ),
                      );
                  context.read<SubjectOverviewSelectionBloc>().add(
                        SubjectOverviewCardSelectionChange(
                          cardUID: data.uid,
                        ),
                      );
                }
              }
            },
            builder: (context, candidateData, rejectedData) {
              return ValueListenableBuilder(
                valueListenable: context
                    .read<SubjectBloc>()
                    .cardsRepository
                    .getChildrenById(folder.uid),
                builder: (context, value, child) {
                  return FolderListTileView(
                    isHovered: isHovered,
                    folder: folder,
                    childListTiles: value.map((e) {
                      if (e is Folder) {
                        return FolderListTileParent(
                            folder: e, cardsRepository: cardsRepository);
                      } else {
                        return CardListTile(card: e as Card);
                      }
                    }).toList(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
