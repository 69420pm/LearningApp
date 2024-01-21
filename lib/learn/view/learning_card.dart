import 'dart:math' as math;

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';

class LearningCard extends StatelessWidget {
  LearningCard(
      {super.key,
      required this.card,
      required this.screenHeight,
      required this.relativeToCurrentIndex});

  final RenderCard card;
  final double screenHeight;
  final int relativeToCurrentIndex;

  PageController pageController = PageController(keepPage: true);

  @override
  Widget build(BuildContext context) {
    final Widget front = CardFace(
        height: card.cardHeight ?? screenHeight,
        widgets: card.frontWidgets,
        relativeToCurrentIndex: relativeToCurrentIndex,
        isTurned: card.turnedOver);
    final Widget back = CardFace(
      height: card.cardHeight ?? screenHeight,
      widgets: card.backWidgets,
      relativeToCurrentIndex: relativeToCurrentIndex,
      isTurned: card.turnedOver,
    );

    final screenWidth = MediaQuery.sizeOf(context).width;

    final matrix = Matrix4.identity()..setEntry(3, 2, 0.0003);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: pageController,
      physics: const PageScrollPhysics(),
      child: SizedBox(
        width: screenWidth * 2,
        child: Animate(
          adapter: ScrollAdapter(
            pageController,
          ),
          onPlay: (controller) => controller.repeat(reverse: true),
        ).custom(
          duration: 2.seconds,
          begin: 0,
          end: 1,
          builder: (_, value, __) {
            if (value > .5 && !card.turnedOver) {
              context.read<LearnCubit>().turnOverCurrentCard();
            }
            return Padding(
              padding: EdgeInsets.only(left: screenWidth * value),
              child: Stack(
                children: [
                  Transform(
                    transform: matrix.clone()
                      ..rotateY(math.pi * value.clamp(0, .5)),
                    alignment: Alignment.center,
                    child: front,
                  ),
                  Transform(
                    transform: matrix.clone()
                      ..rotateY(math.pi * (value.clamp(.5, 1) + 1)),
                    alignment: Alignment.center,
                    child: back,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CardFace extends StatelessWidget {
  const CardFace(
      {super.key,
      required this.widgets,
      required this.height,
      required this.relativeToCurrentIndex,
      required this.isTurned});

  final List<Widget> widgets;
  final double height;
  final int relativeToCurrentIndex;
  final bool isTurned;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height,
        maxWidth: MediaQuery.sizeOf(context).width,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultSize * 2,
          vertical: UIConstants.defaultSize * 3,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isTurned ? Colors.green : UIColors.overlay,
            borderRadius: const BorderRadius.all(
                Radius.circular(UIConstants.cornerRadius)),
          ),
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              Text(relativeToCurrentIndex.toString()),
              ...widgets,
            ],
          ),
        ),
      ),
    );
  }
}
