// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile_view.dart';
import 'package:learning_app/subject_overview/view/dragging_tile.dart';
import 'package:learning_app/subject_overview/view/inactive_list_tile.dart';
import 'package:learning_app/subject_overview/view/multi_drag_indicator.dart';

class CardListTile extends StatelessWidget {
  CardListTile({
    super.key,
    required this.card,
    required this.cardsRepository,
  });
  final Card card;
  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    final isSelected =
        context.read<SubjectOverviewSelectionBloc>().isFileSelected(card.uid);

    final isInDrag = context.read<SubjectOverviewSelectionBloc>().isInDragging;

    return BlocBuilder<SubjectOverviewSelectionBloc,
        SubjectOverviewSelectionState>(
      builder: (context, state) {
        return DraggingTile(
          fileUID: card.uid,
          cardsRepository: cardsRepository,
          child: CardListTileView(
            isSelected: isSelected,
            card: card,
          ),
        );
      },
    );
  }
}
