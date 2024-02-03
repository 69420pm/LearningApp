import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/editor/widgets/editor_tiles/front_back_seperator_tile.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/learn/view/learning_card.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';

class CardPreviewBottomSheet extends StatelessWidget {
  CardPreviewBottomSheet({
    super.key,
    required this.card,
    required CardsRepository cardsRepository,
  }) : _cardsRepository = cardsRepository;

  final Card card;
  final CardsRepository _cardsRepository;

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      addPadding: false,
      actionRight: UIIconButton(
        icon: UIIcons.edit.copyWith(size: 32),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(
            '/add_card',
            arguments: [card, null],
          );
        },
      ),
      child: FutureBuilder(
        future: _cardsRepository.getCardContent(card.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final renderCard = RenderCard(
              onImagesLoaded: () {},
              card: card,
              turnedOver: true,
              cardsRepository: _cardsRepository,
            )..editorTiles = snapshot.requireData;
            return Column(
              children: [
                Column(
                  children: renderCard.frontWidgets,
                ),
                FrontBackSeparatorTile(),
                Column(
                  children: renderCard.backWidgets,
                ),
                const SizedBox(
                  height: UIConstants.itemPaddingLarge,
                ),
              ],

            );
          }
          return const Text('loading');
        },
      ),
    );
  }
}
