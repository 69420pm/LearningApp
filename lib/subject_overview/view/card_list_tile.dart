// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile_view.dart';
import 'package:learning_app/subject_overview/view/dragging_tile.dart';
import 'package:learning_app/subject_overview/view/inactive_list_tile.dart';

class CardListTile extends StatelessWidget {
  const CardListTile({
    super.key,
    required this.card,
    required this.cardsRepository,
  });
  final Card card;
  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectOverviewSelectionBloc,
        SubjectOverviewSelectionState>(
      builder: (context, state) {
        final selectionBloc = context.read<SubjectOverviewSelectionBloc>();

        final isSelectedWhileDraggingButIsNotDraggedTile =
            selectionBloc.isInSelectMode &&
                selectionBloc.isInDragging &&
                selectionBloc.isFileSelected(card.uid) &&
                selectionBloc.fileDragged != card.uid;

        if (isSelectedWhileDraggingButIsNotDraggedTile) {
          return const InactiveListTile();
        }
        {
          return DraggingTile(
            fileUID: card.uid,
            cardsRepository: cardsRepository,
            child: CardListTileView(
              card: card,
            ),
          );
        }
      },
    );
  }
}
