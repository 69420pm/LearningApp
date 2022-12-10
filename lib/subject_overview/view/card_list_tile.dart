import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/card_list_tile_bloc.dart';
import 'package:ui_components/ui_components.dart';

class CardListTile extends StatelessWidget {
  const CardListTile(
      {super.key, required this.card, required this.cardsRepository});

  final Card card;
  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardListTileBloc(cardsRepository),
      child: CardListTileView(
        card: card,
        cardsRepository: cardsRepository,
      ),
    );
  }
}

class CardListTileView extends StatelessWidget {
  const CardListTileView(
      {super.key, required this.card, required this.cardsRepository});

  final Card card;
  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: card,
      feedback: CardListTile(
        card: card,
        cardsRepository: cardsRepository,
      ),
      child: Container(
        width:
            MediaQuery.of(context).size.width - UISizeConstants.paddingEdge * 2,
        height: UISizeConstants.defaultSize * 5,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(UISizeConstants.cornerRadius),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: UISizeConstants.defaultSize * 2,
                vertical: UISizeConstants.defaultSize),
            child: Row(
              children: [
                Text(
                  card.front,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer),
                ),
                IconButton(
                  onPressed: () {
                    /// delete card
                    context.read<CardListTileBloc>().add(
                          CardListTileDeleteCard(
                            id: card.id,
                            parentId: card.parentId,
                          ),
                        );
                  },
                  icon: const Icon(Icons.delete),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
