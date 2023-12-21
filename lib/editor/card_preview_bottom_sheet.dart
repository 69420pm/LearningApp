import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/editor/card_content_widget.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';import 'package:flutter_bloc/flutter_bloc.dart';

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
    final maxHeight = MediaQuery.of(context).size.height * 0.7;
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
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: Column(
                children: [
                  CardContentWidget(
                    editorTiles: snapshot.data!,
                    cardsRepository: _cardsRepository,
                  ),
                ],
              ),
            );
          }
          return const Text("loading");
        },
      ),
    );
  }
}
