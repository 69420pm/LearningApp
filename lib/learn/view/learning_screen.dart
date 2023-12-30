import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/learn/view/learning_card.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key, required this.cardsRepository});
  final CardsRepository cardsRepository;

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final controller = ScrollController();
  List<RenderCard> cardsToLearn = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    context.read<LearnCubit>().learnAllCards();

    return Scaffold(
      backgroundColor: UIColors.background,
      appBar: UIAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return BlocBuilder<LearnCubit, LearnCubitState>(
              buildWhen: (previous, current) =>
                  current is FinishedLoadingCardsState,
              builder: (context, state) {
                cardsToLearn = context.read<LearnCubit>().cardsToLearn;
                return NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    var scrollRatio = 0;

                    if (scrollRatio > 0.5) {
                    } else {}
                    return false;
                  },
                  child: CustomScrollView(
                    controller: controller,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: cardsToLearn.length,
                          (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: LearningCard(
                              card: cardsToLearn[index],
                              index: index,
                              screenHeight: constraints.maxHeight,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
