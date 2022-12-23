import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/view/learning_card.dart';
import 'package:ui_components/ui_components.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Card card = context.read<LearnCubit>().learnAllCards();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: UIAppBar(
        title: const Text('Learning Site'),
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: UISizeConstants.paddingEdge),
        child: Column(
          children: [
            const SizedBox(height: UISizeConstants.defaultSize * 2),
            LearningCard(card: card),
            BlocBuilder<LearnCubit, LearnState>(
              builder: (context, state) {
                return Opacity(
                  opacity: state is BackState ? 1 : 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: UISizeConstants.defaultSize * 3,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        UIButton(
                          onTap: () => context.read<LearnCubit>().newCard(-1),
                          lable: 'bad',
                          color: Colors.red,
                          textColor: Colors.black,
                        ),
                        UIButton(
                          onTap: () => context.read<LearnCubit>().newCard(0),
                          lable: 'middle',
                          textColor: Colors.black,
                          color: Colors.yellow,
                        ),
                        UIButton(
                          onTap: () => context.read<LearnCubit>().newCard(1),
                          lable: 'good',
                          textColor: Colors.black,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
