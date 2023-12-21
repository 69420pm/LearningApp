// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_bloc/subject_bloc.dart';
import 'package:learning_app/subject_overview/view/inactive_list_tile.dart';
import 'package:learning_app/subject_overview/view/multi_drag_indicator.dart';

class DraggingTile extends StatelessWidget {
  const DraggingTile({
    super.key,
    required this.fileUID,
    required this.child,
    required this.cardsRepository,
  });

  final String fileUID;
  final CardsRepository cardsRepository;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isCard = cardsRepository.objectFromId(fileUID) is Card;
    final isFolder = cardsRepository.objectFromId(fileUID) is Folder;
    final isRootFolder = cardsRepository.objectFromId(fileUID) is Subject;

    final selectionBloc = context.read<SubjectOverviewSelectionBloc>();

    final isInSelectMode = selectionBloc.isInSelectMode;

    final isSoftSelected = selectionBloc.fileSoftSelected == fileUID;

    final isSelected = !isRootFolder && selectionBloc.isFileSelected(fileUID);

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
        } else if (!(isRootFolder && selectionBloc.fileSoftSelected.isEmpty)) {
          //change soft selection
          context.read<SubjectOverviewSelectionBloc>().add(
                SubjectOverviewSetSoftSelectFile(
                  fileUID: isSoftSelected
                      ? ''
                      : isRootFolder
                          ? ''
                          : fileUID,
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
          context.read<SubjectOverviewSelectionBloc>().add(
                SubjectOverviewDraggingChange(
                  inDragg: true,
                  draggedFileUID: fileUID,
                ),
              );
        },
        onDragEnd: (details) {
          context.read<SubjectOverviewSelectionBloc>().add(
                SubjectOverviewDraggingChange(
                  inDragg: false,
                  draggedFileUID: '',
                ),
              );
        },
        onDraggableCanceled: (_, __) {
          //Start SelectionMode
          if (isInSelectMode) {
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewDraggingChange(
                    inDragg: false,
                    draggedFileUID: '',
                  ),
                );
          } else {
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewSelectionToggleSelectMode(
                    inSelectMode: true,
                  ),
                ); //select File
            if (isCard) {
              context
                  .read<SubjectOverviewSelectionBloc>()
                  .add(SubjectOverviewCardSelectionChange(cardUID: fileUID));
            } else if (isFolder) {
              context.read<SubjectOverviewSelectionBloc>().add(
                    SubjectOverviewFolderSelectionChange(folderUID: fileUID),
                  );
            }
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
    final isHovered =
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
        if (inSelectMode) {
          //move hole selection
          context.read<SubjectOverviewSelectionBloc>().add(
                SubjectOverviewSelectionMoveSelection(parentId: folderUID),
              );
        }
        //if dragged and dropped in same folder
        else if (cardsRepository.getParentIdFromChildId(fileUID) == folderUID) {
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
        } else {
          //move single file
          context.read<SubjectBloc>().add(
                SubjectSetFileParent(
                  fileUID: fileUID,
                  parentId: folderUID,
                ),
              );
          context.read<SubjectOverviewSelectionBloc>().add(
              SubjectOverviewSelectionToggleSelectMode(inSelectMode: false));
        }
      },
      builder: (context, candidateData, rejectedData) {
        return child;
      },
    );
  }
}
