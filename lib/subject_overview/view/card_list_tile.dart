import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:ui_components/ui_components.dart';

class CardListTile extends StatelessWidget {
  const CardListTile({super.key, required this.card});

  final Card card;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: card,
      feedback: CardListTile(card: card),
      child: Container(
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
            child: Text(
              card.front,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
          ),
        ),
      ),
    );
  }
}
