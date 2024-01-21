import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/view/learning_card_page.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/ui_components/widgets/ui_page.dart';

class LearningScreen extends StatelessWidget {
  LearningScreen({super.key, required this.cardsRepository});
  final CardsRepository cardsRepository;

  final controller = ScrollController();

  bool isFlinging = false;
  bool inAnimation = false;

  void _animateToCurrentCard(BuildContext context) {
    final offsetToAnimate = context
        .read<LearnCubit>()
        .getOffsetByIndex(context.read<LearnCubit>().currentIndex);

    context.read<LearnCubit>().startAnimation();

    controller
        .animateTo(
      offsetToAnimate,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    )
        .then((value) {
      context.read<LearnCubit>().endAnimation();
    });
  }

  void _animateToBiggestCard(BuildContext context, double screenHeight) {
    final offsetToAnimate = context.read<LearnCubit>().getOffsetToBiggestCard(
          controller.offset,
          screenHeight,
        );

    if (offsetToAnimate != null) {
      context.read<LearnCubit>().startAnimation();

      controller
          .animateTo(
        offsetToAnimate,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      )
          .then((value) {
        context.read<LearnCubit>().endAnimation();
      });
    }
  }

  void _flingAnimate(BuildContext context, double vel, double screenHeight) {
    final minFlingVel = 10;
    final currentIndex = context.read<LearnCubit>().currentIndex;

    if (vel.abs() < minFlingVel ||
        (!context.read<LearnCubit>().currentCardIsTurned())) {
      print("moin");
      _animateToBiggestCard(context, screenHeight);
    } else {
      print(context.read<LearnCubit>().currentCardIsTurned());
      final newIndex = vel > 0 ? (currentIndex + 1) : (currentIndex - 1);

      context.read<LearnCubit>().startAnimation();
      context.read<LearnCubit>().updateCurrentIndex(newIndex);

      final offsetToAnimate =
          context.read<LearnCubit>().getOffsetByIndex(newIndex);

      controller
          .animateTo(
        offsetToAnimate,
        duration: Duration(
            milliseconds: min(
                500,
                ((2 *
                            (offsetToAnimate - controller.offset) /
                            controller.position.activity!.velocity) *
                        1000)
                    .round()
                    .abs())),
        curve: Curves.easeOut,
      )
          .then((value) {
        context.read<LearnCubit>().endAnimation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return UIPage(
      addPadding: false,
      appBar: const UIAppBar(
        appBarColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          return BlocBuilder<LearnCubit, LearnCubitState>(
            buildWhen: (previous, current) {
              if (current is FinishedLoadingCardsState) return true;
              // if (current is NextLearningSessionState) return true;
              // if (current is CardTurnedState) return true;

              if (current is StartAnimationState) inAnimation = true;
              if (current is FinishedAnimationState) inAnimation = false;

              if (current is FinishedLearningState) {
                Navigator.of(context).pop();
              }

              return false;
            },
            builder: (context, state) {
              if (state is NextLearningSessionState) {
                controller.animateTo(0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut);
              }
              return GestureDetector(
                onTapDown: (details) {
                  isFlinging = false;
                  inAnimation = false;
                },
                //called if card got flung, stopped, finger up without movement
                onTapUp: (details) {
                  _animateToCurrentCard(context);
                },
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    // check if notification comes from vertical scroll view
                    if (notification.depth == 0) {
                      // Check if the scroll view is being flung (finger down, moved, finger up)
                      if (notification is ScrollUpdateNotification &&
                          notification.dragDetails == null &&
                          !inAnimation) {
                        if (!isFlinging) {
                          isFlinging = true;
                        }
                        if (!context
                            .read<LearnCubit>()
                            .isScrollingInsideCurrentCard(
                                controller.offset, screenHeight)) {
                          _flingAnimate(
                              context, notification.scrollDelta!, screenHeight);
                        } else {}
                      }

                      // Check if Scrollview comes to an stop without getting flung (finger down, moved, stopped, finger up)
                      else if (notification is UserScrollNotification &&
                          notification.direction == ScrollDirection.idle &&
                          !isFlinging &&
                          !inAnimation) {
                        _animateToBiggestCard(context, screenHeight);
                      }

                      // Check if Scrollview got flung (finger down, moved, finger up, scrollview scrolles on, scrollview comes to a stop)
                      else if (notification is UserScrollNotification &&
                          notification.direction == ScrollDirection.idle &&
                          isFlinging) {
                        isFlinging = false;
                      }
                    }

                    return false;
                  },
                  child: CustomScrollView(
                    physics: ClampingScrollPhysics(),
                    controller: controller,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount:
                              context.read<LearnCubit>().cardsToLearn.length,
                          (context, index) => LearningCardPage(
                            cardsRepository: cardsRepository,
                            card:
                                context.read<LearnCubit>().cardsToLearn[index],
                            index: index,
                            screenHeight: screenHeight,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
