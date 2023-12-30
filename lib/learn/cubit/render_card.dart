import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/editor/models/editor_tile.dart';

class RenderCard extends Card {
  RenderCard({
    required Card card,
    this.turnedOver = false,
    this.cardHeight,
    this.frontTiles,
    this.backTiles,
  }) : super(
          uid: card.uid,
          dateCreated: card.dateCreated,
          askCardsInverted: card.askCardsInverted,
          typeAnswer: card.typeAnswer,
          recallScore: card.recallScore,
          dateToReview: card.dateToReview,
          name: card.name,
        );

  bool turnedOver;
  double? cardHeight;
  List<EditorTile>? frontTiles;
  List<EditorTile>? backTiles;
}
