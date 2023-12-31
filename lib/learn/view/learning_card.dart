import 'package:flutter/material.dart' hide Card;
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
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
    required this.cardsRepository,
  });
  final RenderCard card;
  final int index;
  final double screenHeight;
  final CardsRepository cardsRepository;

  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      key: globalKey,
      constraints: BoxConstraints(
        minHeight: screenHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.cardHorizontalPadding,
            vertical: UIConstants.itemPaddingLarge),
        child: BlocBuilder<LearnCubit, LearnCubitState>(
          builder: (context, state) {
            // Save to avoid unsafe Warnings
            final learnCubit = context.read<LearnCubit>();

            SchedulerBinding.instance.addPostFrameCallback((duration) {
              var widgetHeight = screenHeight;
              final renderBox =
                  globalKey.currentContext?.findRenderObject() as RenderBox?;
              if (renderBox != null && renderBox.hasSize) {
                widgetHeight = renderBox.size.height;
              }

              learnCubit.setHeight(index, widgetHeight);
            });

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.read<LearnCubit>().turnOverCard(index),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: card.turnedOver
                      ? Colors.red.withOpacity(0.2)
                      : UIColors.overlay,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(UIConstants.cornerRadius),
                  ),
                ),
                child: Column(
                  children: [
                    Text(card.name),
                    ...card.frontWidgets,
                    if (card.turnedOver) ...card.backWidgets,
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
