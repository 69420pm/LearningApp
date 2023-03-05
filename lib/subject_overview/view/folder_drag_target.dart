import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/edit_subject_bloc/subject_overview_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';

class FolderDragTarget extends StatelessWidget {
  const FolderDragTarget(
      {super.key, required this.parentID, required this.child});

  final String parentID;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onAccept: (data) {
        if (data is Folder) {
          if(data.parentId == parentID) return;
          context.read<EditSubjectBloc>().add(
                EditSubjectSetFolderParent(
                  folder: data,
                  parentId: parentID,
                ),
              );
        } else if (data is Card) {
          if (data.parentId != parentID) {
            if (context.read<SubjectOverviewSelectionBloc>().state
                is SubjectOverviewSelectionMultiDragging) {
              context.read<SubjectOverviewSelectionBloc>().add(
                    SubjectOverviewSelectionMoveSelectedCards(
                      parentId: parentID,
                    ),
                  );
            } else {
              context.read<EditSubjectBloc>().add(
                    EditSubjectSetCardParent(
                      card: data,
                      parentId: parentID,
                    ),
                  );
            }
          } else if (context
              .read<SubjectOverviewSelectionBloc>()
              .isInSelectMode) {
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewSelectionMoveSelectedCards(
                    parentId: parentID,
                  ),
                );
          } else {
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewSelectionToggleSelectMode(
                    inSelectMode: true,
                  ),
                );
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewSelectionChange(
                    card: data,
                    addCard: true,
                  ),
                );
          }
        }
        // print(data);
        // folder.childFolders.add(data);
      },
      builder: (context, candidateData, rejectedData) {
        return child;
      },
    );
  }
}
