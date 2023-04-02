// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/subject_overview/view/card_list_tile_view.dart';
import 'package:ui_components/ui_components.dart';

class CardListTileMultiDragIndicator extends StatelessWidget {
  const CardListTileMultiDragIndicator({
    Key? key,
    required this.cardAmount,
    required this.firstCard,
    required this.height,
    required this.width,
  }) : super(key: key);

  final int cardAmount;
  final Card firstCard;

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        cardAmount,
        (index) => Transform.rotate(
          angle: index == cardAmount - 1
              ? 0
              : 1 / 30 * pi * Random().nextDouble() - 1 / 50 * pi,
          alignment: Alignment(
              Random().nextDouble() * 2 - 1, Random().nextDouble() * 2 - 1),
          child: CardListTileView(
            card: index == cardAmount - 1
                ? firstCard
                : const Card(
                    askCardsInverted: false,
                    back: '',
                    dateCreated: '',
                    dateToReview: '',
                    front: '',
                    id: '',
                    parentId: '',
                    typeAnswer: false,
                    tags: []),
            isSelected: true,
            height: height,
            width: width,
          ),
        ),
      ),
    );
  }
}
