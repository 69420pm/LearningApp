import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;

class LearningCardBack extends StatelessWidget {
  const LearningCardBack({super.key, required this.cardBack});
  final String cardBack;
  @override
  Widget build(BuildContext context) {
    return Text(
      cardBack,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
