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

class LearningScreen extends StatelessWidget {
  LearningScreen({super.key, required this.cardsRepository});
  final CardsRepository cardsRepository;

  final controller = ScrollController();
  List<RenderCard> cardsToLearn = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    context.read<LearnCubit>().learnAllCards();

    return Scaffold(
      backgroundColor: UIColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller
              .jumpTo(context.read<LearnCubit>().getOffsetOfCardByIndex(10));
        },
      ),
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
                    if (notification.direction == ScrollDirection.idle) {
                      var offsetToAnimate =
                          context.read<LearnCubit>().getOffsetToAnimate(
                                controller.offset,
                                constraints.maxHeight,
                              );

                      if (offsetToAnimate != null) {
                        context.read<LearnCubit>().startAnimation();
                        controller
                            .animateTo(
                          offsetToAnimate,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        )
                            .then((value) {
                          context.read<LearnCubit>().endAnimation();
                        });
                      }
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    controller: controller,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: cardsToLearn.length,
                          (context, index) => LearningCard(
                            card: cardsToLearn[index],
                            index: index,
                            screenHeight: constraints.maxHeight,
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
