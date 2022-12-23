import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/view/card.dart';
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
        child: Column(
          children: [
            const SizedBox(height: UISizeConstants.defaultSize * 2),
            const LearningCard(),
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
                          lable: 'D runter',
                          color: Colors.red,
                          textColor: Colors.black,
                        ),
                        UIButton(
                          onTap: () => context.read<LearnCubit>().newCard(0),
                          lable: 'D mitte',
                          textColor: Colors.black,
                          color: Colors.yellow,
                        ),
                        UIButton(
                          onTap: () => context.read<LearnCubit>().newCard(1),
                          lable: 'D hoch',
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
