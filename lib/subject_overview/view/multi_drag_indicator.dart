// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:ui_components/ui_components.dart';

import 'package:learning_app/subject_overview/view/card_list_tile_view.dart';

class MultiDragIndicator extends StatelessWidget {
  const MultiDragIndicator({
    super.key,
    this.cardAmount = 0,
    this.folderAmount = 0,
    this.firstCardName,
    this.firstFolderName,
  });

  final int cardAmount;
  final int folderAmount;
  final List<String>? firstCardName;
  final List<String>? firstFolderName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[] /* List.generate(
        cardAmount,
        (index) => Transform.rotate(
          angle: index == cardAmount - 1
              ? 0
              : 1 / 30 * pi * Random().nextDouble() - 1 / 50 * pi,
          alignment: Alignment(
              Random().nextDouble() * 2 - 1, Random().nextDouble() * 2 - 1,),
          child: CardListTileView(
            card: index == cardAmount - 1
                ? firstCard
                :  Card(
                    askCardsInverted: false,
                    dateCreated: DateTime.now(),
                    dateToReview: DateTime.now(),
                    uid: '',
                    typeAnswer: false,
                    parents: [],
                    recallScore: 0),
            isSelected: true,
            height: height,
            width: width,
          ),
        ),
      ), */
    );
  }
}

class AmountIndicator extends StatelessWidget {
  const AmountIndicator({
    Key? key,
    required this.amount,
    required this.icon,
  }) : super(key: key);

  final int amount;
  final UIIcon icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: amount > 0
          ? [
              if (amount > 1)
                DefaultTextStyle(
                  //* or else yellow lines below text
                  style: Theme.of(context).textTheme.bodyMedium!,
                  child: Text(
                    amount.toString(),
                    style: UIText.label,
                  ),
                ),
              if (amount > 1)
                const SizedBox(width: UIConstants.itemPaddingSmall),
              icon
            ]
          : [],
    );
  }
}
