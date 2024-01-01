import 'package:flutter/material.dart' hide Card;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/learn/view/learning_card_page.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';

class LearningScreen extends StatelessWidget {
  LearningScreen({super.key, required this.cardsRepository});
  final CardsRepository cardsRepository;

  final controller = ScrollController();
  List<RenderCard> cardsToLearn = List.empty(growable: true);

  OverlayEntry? overlayEntry;

  void showRatingButtons(BuildContext context) {
    final overlay = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return UIIconButton(
          icon: UIIcons.add,
          onPressed: () =>
              context.read<LearnCubit>().rateCard(LearnFeedback.good));
    });
    overlay.insert(overlayEntry!);
  }

  void hideRatingButtons(BuildContext context) {
    overlayEntry!.remove();
    overlayEntry!.dispose();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    context.read<LearnCubit>().loadTodaysCards();

    return Scaffold(
      backgroundColor: UIColors.background,
      appBar: UIAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            return BlocBuilder<LearnCubit, LearnCubitState>(
              buildWhen: (previous, current) {
                if (current is CardTurnedState) {
                  return true;
                }
                if (current is CardRatedState) {
                  return true;
                }
                return current is FinishedLoadingCardsState;
              },
              builder: (context, state) {
                if (state is CardTurnedState) {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => showRatingButtons(context));
                }
                if (state is CardRatedState) {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => hideRatingButtons(context));
                }
                cardsToLearn = context.read<LearnCubit>().cardsToLearn;
                return NotificationListener<ScrollNotification>(
                  // onNotification: (notification) {
                  //   if (notification is! ScrollEndNotification) {
                  //     var bottomLimit = context
                  //         .read<LearnCubit>()
                  //         .getBottomLimit(screenHeight, controller.offset,
                  //             notification is ScrollStartNotification);

                  //     if (notification.metrics.pixels > bottomLimit &&
                  //         state is! StopScrollingState) {
                  //       context.read<LearnCubit>().stopScrolling();
                  //       controller
                  //           .animateTo(bottomLimit,
                  //               duration: Duration(milliseconds: 300),
                  //               curve: Curves.easeInOut)
                  //           .then((value) =>
                  //               context.read<LearnCubit>().endAnimation());
                  //     }
                  //   }
                  //   return false;
                  // },
                  child: NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      if (notification.direction == ScrollDirection.idle) {
                        var offsetToAnimate =
                            context.read<LearnCubit>().getOffsetToAnimate(
                                  controller.offset,
                                  screenHeight,
                                );

                        if (offsetToAnimate != null &&
                            controller.position.activity
                                is IdleScrollActivity &&
                            state is! StopScrollingState &&
                            state is! StartAnimationState) {
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
                      return false;
                    },
                    child: CustomScrollView(
                      controller: controller,
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: cardsToLearn.length,
                            (context, index) => LearningCardPage(
                              cardsRepository: cardsRepository,
                              card: cardsToLearn[index],
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
      ),
    );
  }
}
