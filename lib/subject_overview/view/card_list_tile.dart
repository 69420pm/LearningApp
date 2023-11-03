// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile_view.dart';
import 'package:learning_app/subject_overview/view/inactive_list_tile.dart';
import 'package:learning_app/subject_overview/view/multi_drag_indicator.dart';

class CardListTile extends StatelessWidget {
  CardListTile({
    super.key,
    required this.card,
  });
  final Card card;

  @override
  Widget build(BuildContext context) {
    void changeCardSelection(BuildContext context) {
      context.read<SubjectOverviewSelectionBloc>().add(
            SubjectOverviewCardSelectionChange(cardUID: card.uid),
          );
    }

    final isSelected =
        context.read<SubjectOverviewSelectionBloc>().isFileSelected(card.uid);

    final isInSelectMode =
        context.read<SubjectOverviewSelectionBloc>().isInSelectMode;

    final isInDragg = context.read<SubjectOverviewSelectionBloc>().isInDragging;

    return GestureDetector(
      onTap: () {
        if (isInSelectMode) {
          changeCardSelection(context);
        }else{
          // open card in editor
          Navigator.of(context).pushNamed(
                    '/add_card',
                    arguments: [
                      card,
                      null
                    ],
                  );
        }
      },
      child: LongPressDraggable(
        data: card,
        maxSimultaneousDrags: isInSelectMode && !isSelected ? 0 : 1,
        onDragStarted: () {
          context
              .read<SubjectOverviewSelectionBloc>()
              .add(SubjectOverviewDraggingChange(inDragg: true));
        },
        onDragEnd: (details) {
          context
              .read<SubjectOverviewSelectionBloc>()
              .add(SubjectOverviewDraggingChange(inDragg: false));

          context.read<FolderListTileBloc>().add(FolderListTileClearHovers());
        },
        onDraggableCanceled: (_, __) {
          if (!isSelected) {
            context.read<SubjectOverviewSelectionBloc>().add(
                  SubjectOverviewSelectionToggleSelectMode(
                    inSelectMode: true,
                  ),
                );
            changeCardSelection(context);
          }
        },
        feedback: MultiDragIndicator(
          cardAmount: context
              .read<SubjectOverviewSelectionBloc>()
              .selectedFiles
              .length
              .clamp(1, 10),
          firstCardName: [
            "TODO get card front"
          ], //TODO get front of card as String
        ),
        childWhenDragging: const InactiveListTile(),
        child: CardListTileView(
          isSelected: isSelected,
          card: card,
          isChildWhenDragging: isInDragg && isSelected, //! Broken I guess
        ),
      ),
    );
  }
}
