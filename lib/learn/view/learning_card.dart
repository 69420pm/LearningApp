import 'dart:math' as math;

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';

class LearningCard extends StatelessWidget {
  LearningCard({super.key, required this.card, required this.screenHeight});

  final RenderCard card;
  final double screenHeight;

  PageController pageController = PageController(keepPage: true);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: pageController,
      physics: PageScrollPhysics(),
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
            return Padding(
              padding: EdgeInsets.only(left: screenWidth * value),
              child: Stack(
                children: [
                  Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0005)
                      ..rotateY(math.pi * value.clamp(0, .5)),
                    alignment: Alignment.center,
                    child: CardFace(
                      widgets: card.frontWidgets,
                      screenHeight: screenHeight,
                    ),
                  ),
                  Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0005)
                      ..rotateY(math.pi * (value.clamp(.5, 1) + 1)),
                    alignment: Alignment.center,
                    child: CardFace(
                      widgets: card.backWidgets,
                      screenHeight: screenHeight,
                    ),
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
      {super.key, required this.widgets, required this.screenHeight});

  final List<Widget> widgets;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: screenHeight, maxWidth: MediaQuery.sizeOf(context).width),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.defaultSize,
            vertical: UIConstants.defaultSize * 3),
        child: Container(
          decoration: const BoxDecoration(
            color: UIColors.overlay,
            borderRadius:
                BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),
          ),
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              ...widgets,
            ],
          ),
        ),
      ),
    );
  }
}
