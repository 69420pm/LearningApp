import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/card_list_tile_bloc.dart';
import 'package:ui_components/ui_components.dart';

class CardDraggableListTile extends StatelessWidget {
  const CardDraggableListTile({super.key, required this.card});

  final Card card;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UISizeConstants.defaultSize),
      child: Container(
        width: UISizeConstants.defaultSize * 20,
        height: UISizeConstants.defaultSize * 20,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(UISizeConstants.cornerRadius),
          ),
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                card.front,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
