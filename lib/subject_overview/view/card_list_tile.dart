import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:ui_components/ui_components.dart';

class CardListTile extends StatelessWidget {
  const CardListTile({super.key, required this.card});

  final Card card;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: Text("fd"),
      child: Container(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: UISizeConstants.defaultSize * 2,
              vertical: UISizeConstants.defaultSize),
          child: Column(
            children: [
              Text(
                card.front,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.all(
            Radius.circular(UISizeConstants.cornerRadius),
          ),
        ),
      ),
    );
  }
}
