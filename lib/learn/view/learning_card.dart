import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/ui_components/ui_constants.dart';

class LearningCard extends StatelessWidget {
  const LearningCard({super.key, required this.card});

  final RenderCard card;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(card.name),
        Text(card.dateToReview.toString()),
        ...card.frontWidgets,
        if (card.turnedOver) ...card.backWidgets,
      ],
    );
  }
}
