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
    final Widget front = CardFace(
      height: card.cardHeight ?? screenHeight,
      widgets: card.frontWidgets,
    );
    final Widget back = CardFace(
      height: card.cardHeight ?? screenHeight,
      widgets: card.backWidgets,
    );

    final screenWidth = MediaQuery.sizeOf(context).width;

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
            return Padding(
              padding: EdgeInsets.only(left: screenWidth * value),
              child: Stack(
                children: [
                  Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0003)
                      ..rotateY(math.pi * value.clamp(0, .5)),
                    alignment: Alignment.center,
                    child: front,
                  ),
                  Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0003)
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
  const CardFace({super.key, required this.widgets, required this.height});

  final List<Widget> widgets;
  final double height;

  @override
  Widget build(BuildContext context) {
    //iterations to finish card
    const rehearsalIterations = 5;

    //minimal time it takes to finish a card if always rated good
    const minimalAmountDaysToLearnCard = 14;

    //rehearsal Curve (lots in the beginning, fewer in the end)
    const rehearsalCurve = Curves.easeInExpo;

    // generate list of time spans between rehearsals
    final nextDateToReview = List.generate(
      rehearsalIterations,
      (index) {
        return (rehearsalCurve.transform(
              (index + 1) / rehearsalIterations,
            ) *
            minimalAmountDaysToLearnCard);
      },
    );

    print(nextDateToReview);
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
