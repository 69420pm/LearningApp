import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';

class LearningCard extends StatelessWidget {
  LearningCard({
    super.key,
    required this.card,
    required this.index,
    required this.screenHeight,
  });
  final RenderCard card;
  final int index;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: screenHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<LearnCubit, LearnCubitState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () => context.read<LearnCubit>().turnOverCard(index),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: UIColors.overlay,
                  borderRadius: BorderRadius.all(
                    Radius.circular(UIConstants.cornerRadius),
                  ),
                ),
                child: Column(
                  children: [
                    Text(card.uid),
                    Text(card.name),
                    Text('$index'),
                    Text(card.dateCreated.toString()),
                    if (card.frontTiles != null) ...card.frontTiles!,
                    if (card.backTiles != null && card.turnedOver)
                      const SizedBox(height: UIConstants.itemPaddingLarge),
                    if (card.backTiles != null && card.turnedOver)
                      ...card.backTiles!,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
