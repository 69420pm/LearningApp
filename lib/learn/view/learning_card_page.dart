import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/learn/view/learning_card.dart';
import 'package:learning_app/ui_components/ui_constants.dart';

class LearningCardPage extends StatelessWidget {
  LearningCardPage({
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
      child: BlocBuilder<LearnCubit, LearnCubitState>(
        buildWhen: (previous, current) {
          if (current is NewCardState) return true;
          if (current is CardTurnedState) return true;
          return false;
        },
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
            child: LearningCard(card: card),
          );
        },
      ),
    );
  }
}
