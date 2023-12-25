import 'package:flutter/material.dart' hide Card;

class LearningCardFront extends StatelessWidget {
  const LearningCardFront({super.key, required this.cardFront});
  final String cardFront;
  @override
  Widget build(BuildContext context) {
    return Text(
      cardFront,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
