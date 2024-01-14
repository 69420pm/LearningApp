import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/widgets/editor_tiles/front_back_seperator_tile.dart';
import 'package:learning_app/editor/widgets/editor_tiles/header_tile.dart';
import 'package:learning_app/editor/widgets/editor_tiles/image_tile.dart';
import 'package:learning_app/editor/widgets/editor_tiles/link_tile.dart';
import 'package:learning_app/editor/widgets/editor_tiles/text_tile.dart';

class RenderCard extends Card {
  RenderCard({
    required Card card,
    required this.cardsRepository,
    required this.onImagesLoaded,
    this.turnedOver = false,
    this.gotRatedBad = false,
    this.gotRatedInThisSession = false,
    this.finishedToday = false,
    this.cardHeight,
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
  bool gotRatedBad;
  bool gotRatedInThisSession;
  bool finishedToday;

  final CardsRepository cardsRepository;
  final void Function() onImagesLoaded;

  List<Widget> _frontWidgets = [];
  List<Widget> get frontWidgets => _frontWidgets;

  List<Widget> _backWidgets = [];
  List<Widget> get backWidgets => _backWidgets;

  List<EditorTile> _editorTiles = [];
  List<EditorTile> get editorTiles => _editorTiles;

  set editorTiles(List<EditorTile> editorTiles) {
    _editorTiles = editorTiles;
    var indexSpacer =
        editorTiles.indexWhere((element) => element is FrontBackSeparatorTile);

    if (indexSpacer == -1) {
      indexSpacer = editorTiles.length;
    }

    final widgets = editorTiles.map((e) {
      if (e is LinkTile) {
        e.cardsRepository = cardsRepository;
      } else if (e is ImageTile) {
        e.onFinishedLoading = onImagesLoaded;
      }
      e.inRenderMode = true;
      return e as Widget;
    }).toList();

    _frontWidgets = widgets.sublist(0, indexSpacer);
    _backWidgets = widgets.sublist(indexSpacer, widgets.length);
  }
}