// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/view/inactive_list_tile.dart';

import '../bloc/folder_bloc/folder_list_tile_bloc.dart';
import '../bloc/subject_bloc/subject_bloc.dart';
import 'multi_drag_indicator.dart';

class DraggingTile extends StatelessWidget {
  const DraggingTile({
    Key? key,
    required this.fileUID,
    required this.child,
    required this.cardsRepository,
  }) : super(key: key);

  final String fileUID;
  final CardsRepository cardsRepository;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isCard = cardsRepository.objectFromId(fileUID) is Card;
    final isFolder = cardsRepository.objectFromId(fileUID) is Folder;
    final isRootFolder = cardsRepository.objectFromId(fileUID) is Subject;

    final isInSelectMode =
        context.read<SubjectOverviewSelectionBloc>().isInSelectMode;

    final isSoftSelected =
        context.read<SubjectOverviewSelectionBloc>().fileUIDSoftSelected ==
            fileUID;

    final isSelected = !isRootFolder &&
        context.read<SubjectOverviewSelectionBloc>().isFileSelected(fileUID);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (isInSelectMode) {
          //change file selection
          if (isCard) {
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewCardSelectionChange(cardUID: fileUID),
                );
          } else if (isFolder) {
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewFolderSelectionChange(folderUID: fileUID),
                );
          }
        } else {
          //change soft selection
          context.read<SubjectOverviewSelectionBloc>().add(
                SubjectOverviewSetSoftSelectFile(
                  fileUID: isSoftSelected ? '' : fileUID,
                ),
              );
        }
      },
      child: LongPressDraggable(
        data: fileUID,
        //makes non selected files not draggable in selectionMode
        maxSimultaneousDrags:
            (isInSelectMode && !isSelected) || isRootFolder ? 0 : 1,

        childWhenDragging: const InactiveListTile(),
        feedback: MultiDragIndicator(
          cardsRepository: cardsRepository,
          fileUIDs: isInSelectMode
              ? context.read<SubjectOverviewSelectionBloc>().selectedFiles
              : [fileUID],
        ),
        onDragStarted: () {
          context
              .read<SubjectOverviewSelectionBloc>()
              .add(SubjectOverviewDraggingChange(inDragg: true));
        },
        onDragEnd: (details) {
          context
              .read<SubjectOverviewSelectionBloc>()
              .add(SubjectOverviewDraggingChange(inDragg: false));
        },
        onDraggableCanceled: (_, __) {
          //Start SelectionMode
          if (!isInSelectMode) {
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewSelectionToggleSelectMode(
                    inSelectMode: true,
                  ),
                );
          }
          //select File
          if (isCard) {
            context
                .read<SubjectOverviewSelectionBloc>()
                .add(SubjectOverviewCardSelectionChange(cardUID: fileUID));
          } else if (isFolder) {
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewFolderSelectionChange(folderUID: fileUID),
                );
          }
        },
        child: Builder(
          builder: (context) {
            if (isCard) {
              return child;
            } else {
              return FolderDragTarget(
                folderUID: fileUID,
                cardsRepository: cardsRepository,
                inSelectMode: isInSelectMode,
                child: child,
              );
            }
          },
        ),
      ),
    );
  }
}

class FolderDragTarget extends StatelessWidget {
  const FolderDragTarget({
    super.key,
    required this.child,
    required this.folderUID,
    required this.cardsRepository,
    required this.inSelectMode,
  });

  final Widget child;
  final String folderUID;
  final CardsRepository cardsRepository;
  final bool inSelectMode;

  @override
  Widget build(BuildContext context) {
    var isHovered =
        context.read<SubjectOverviewSelectionBloc>().hoveredFolderUID ==
            folderUID;
    return DragTarget(
      onMove: (details) {
        if (isHovered == false) {
          context
              .read<SubjectOverviewSelectionBloc>()
              .add(SubjectOverviewSetHoveredFolder(folderUID: folderUID));
        }
      },
      onAccept: (String fileUID) {
        //if dragged and dropped in same folder
        if (cardsRepository.getParentIdFromChildId(fileUID) == folderUID) {
          if (inSelectMode) {
            //move hole selection to this folder
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewSelectionMoveSelection(
                    parentId: folderUID,
                  ),
                );
          } else {
            //start selectionMode
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewSelectionToggleSelectMode(
                    inSelectMode: true,
                  ),
                );
            //select data
            if (cardsRepository.objectFromId(fileUID) is Card) {
              context.read<SubjectOverviewSelectionBloc>().add(
                    SubjectOverviewCardSelectionChange(cardUID: fileUID),
                  );
            } else {
              context.read<SubjectOverviewSelectionBloc>().add(
                    SubjectOverviewFolderSelectionChange(
                      folderUID: fileUID,
                    ),
                  );
            }
          }
          return;
        }

        if (inSelectMode) {
          //move hole selection
          context.read<SubjectOverviewSelectionBloc>().add(
                SubjectOverviewSelectionMoveSelection(parentId: folderUID),
              );
        } else {
          //move data

          context.read<SubjectBloc>().add(
                SubjectSetFileParent(
                  fileUID: fileUID,
                  parentId: folderUID,
                ),
              );
        }
      },
      builder: (context, candidateData, rejectedData) {
        return child;
      },
    );
  }
}
