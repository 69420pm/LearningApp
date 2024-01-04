import 'package:flutter/material.dart' hide Card;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_text.dart';

class LearningCard extends StatelessWidget {
  const LearningCard(
      {super.key, required this.card, required this.isCurrentIndex});

  final RenderCard card;
  final bool isCurrentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(UIConstants.defaultSize),
      decoration: BoxDecoration(
        color: isCurrentIndex ? UIColors.primary : UIColors.overlay,
        borderRadius:
            BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.grey,
            child: Column(
              children: [
                if (card.gotRatedBad) const Text('got bad'),
                if (card.gotRatedInThisSession) const Text('got rated'),
                if (card.finishedToday) const Text('finished today'),
                Text(
                  card.recallScore.toString(),
                  style: UIText.titleBig,
                ),
                Text(
                  DateUtils.dateOnly(card.dateToReview)
                      .toString()
                      .substring(0, 10),
                  style: UIText.titleBig,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.blue,
            child: Column(
              children: [
                ...card.frontWidgets,
              ],
            ),
          ),
          Container(
            color: Colors.red,
            child: Visibility(
              visible: card.turnedOver,
              child: Column(
                children: [
                  ...card.backWidgets,
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // .animate(target: card.turnedOver ? 1 : 0)
    // .color(end: Colors.blue)
    // .animate(
    //     target: card.gotRatedInThisSession && card.finishedToday ? 1 : 0)
    // .color(end: Colors.green, duration: 1.seconds);
  }
}
