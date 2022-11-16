import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ui_components/ui_components.dart';

class CardListTile extends StatelessWidget {
  const CardListTile({super.key, required this.card});

  final Card card;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: UiSizeConstants.defaultSize * 2,
            vertical: UiSizeConstants.defaultSize),
        child: Text(
          card.front,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.all(
          Radius.circular(UiSizeConstants.cornerRadius),
        ),
      ),
    );
  }
}
