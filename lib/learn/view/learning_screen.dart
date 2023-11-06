import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/view/learning_card.dart';
import 'package:ui_components/ui_components.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<LearnCubit>().learnAllCards();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const UIAppBar(
        title: 'Learning Site',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.cardHorizontalPadding,),
        child: BlocBuilder<LearnCubit, LearnState>(
          builder: (context, state) {
            final card = context.read<LearnCubit>().getNextCard();
            if (card == null) {
              return const Text('all cards finished');
            }
            return Column(
              children: [
                const SizedBox(height: UIConstants.defaultSize * 2),
                LearningCard(card: card),
                Column(
                  children: [
                    Opacity(
                      opacity: state is BackState ? 1 : 0,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: UIConstants.defaultSize * 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
