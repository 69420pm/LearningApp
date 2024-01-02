import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_text.dart';

class LearningCard extends StatelessWidget {
  const LearningCard({super.key, required this.card});

  final RenderCard card;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: card.finishedToday
              ? card.gotRatedBad
                  ? Colors.orange
                  : Colors.green
              : card.gotRatedBad
                  ? Colors.red
                  : UIColors.overlay,
          child: Column(
            children: [
              if (card.gotRatedBad) Text("got bad"),
              if (card.gotRatedInThisSession) Text("got rated"),
              if (card.finishedToday) Text("finished today"),
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
        ...card.frontWidgets,
        if (card.turnedOver) ...card.backWidgets,
      ],
    );
  }
}
