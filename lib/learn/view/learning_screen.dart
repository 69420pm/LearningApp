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
      appBar: UIAppBar(
        title: const Text('Learning Site'),
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: UISizeConstants.paddingEdge),
        child: BlocBuilder<LearnCubit, LearnState>(
          builder: (context, state) {
            final card = context.read<LearnCubit>().getNextCard();
            if (card == null) {
              return Text("all cards finished");
            }
            return Column(
              children: [
                const SizedBox(height: UISizeConstants.defaultSize * 2),
                LearningCard(card: card),
                Column(
                  children: [
                    Opacity(
                      opacity: state is BackState ? 1 : 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: UISizeConstants.defaultSize * 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            UIButton(
                              onTap: () => context
                                  .read<LearnCubit>()
                                  .newCard(LearnFeedback.bad, card),
                              lable: 'again',
                              color: Colors.red,
                              textColor: Colors.black,
                            ),
                            UIButton(
                              onTap: () => context
                                  .read<LearnCubit>()
                                  .newCard(LearnFeedback.medium, card),
                              lable: 'almost',
                              textColor: Colors.black,
                              color: Colors.yellow,
                            ),
                            UIButton(
                              onTap: () => context
                                  .read<LearnCubit>()
                                  .newCard(LearnFeedback.good, card),
                              lable: 'easy',
                              textColor: Colors.black,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
