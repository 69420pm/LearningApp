import 'dart:math' as math;

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/learn/view/rate_bar.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';

class LearningCard extends StatefulWidget {
  LearningCard(
      {super.key,
      required this.card,
      required this.screenHeight,
      required this.relativeToCurrentIndex});

  final RenderCard card;
  final double screenHeight;
  final int relativeToCurrentIndex;

  @override
  State<LearningCard> createState() => _LearningCardState();
}

class _LearningCardState extends State<LearningCard> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  Color colorAnimation(double x, Color color, double maxOpacity) {
    if (x < 0.5) {
      return color.withOpacity(x * (1 + maxOpacity));
    } else {
      return color.withOpacity((1 - x) * (1 + maxOpacity));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final matrix = Matrix4.identity()..setEntry(3, 2, 0.0003);

    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: !(widget.relativeToCurrentIndex > 0 &&
          !context.read<LearnCubit>().currentCardIsTurned()),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: pageController,
        physics: const PageScrollPhysics(),
        child: SizedBox(
          width: screenWidth * 2,
          child: Animate(
            adapter: ScrollAdapter(pageController),
          ).custom(
            begin: 0,
            end: 1,
            builder: (_, value, __) {
              if (value > .5 && !widget.card.turnedOver) {
                context.read<LearnCubit>().turnOverCurrentCard();
              }
              return Padding(
                padding: EdgeInsets.only(left: screenWidth * value),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Transform(
                      transform: matrix.clone()
                        ..rotateY(math.pi * value.clamp(0, .5)),
                      alignment: Alignment.center,
                      child: CardFace(
                        isBack: false,
                        card: widget.card,
                        screenHeight: widget.screenHeight,
                      ),
                    ),
                    Transform(
                      transform: matrix.clone()
                        ..rotateY(math.pi * (value.clamp(.5, 1) + 1)),
                      alignment: Alignment.center,
                      child: CardFace(
                        isBack: true,
                        card: widget.card,
                        screenHeight: widget.screenHeight,
                      ),
                    ),
                    Container(
                      height: widget.card.cardHeight,
                      width: screenWidth,
                      color: colorAnimation(value, UIColors.background, .4),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CardFace extends StatelessWidget {
  const CardFace({
    super.key,
    required this.card,
    required this.isBack,
    required this.screenHeight,
  });

  final RenderCard card;
  final bool isBack;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: card.cardHeight ?? screenHeight,
        maxWidth: MediaQuery.sizeOf(context).width,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultSize * 2,
          vertical: UIConstants.defaultSize * 3,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: UIColors.overlay,
            borderRadius: BorderRadius.all(
              Radius.circular(UIConstants.cornerRadius * 1.5),
            ),
          ),
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: UIConstants.defaultSize),
            child: Builder(
              builder: (context) {
                if (isBack) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: card.backWidgets,
                        ),
                        RateBar(index: 0, feedback: card.feedback)
                      ]);
                } else {
                  return Column(
                    children: card.frontWidgets,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
