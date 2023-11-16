import 'package:flutter/material.dart' hide Card;
import 'package:cards_repository/cards_repository.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/card_content_widget.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardPreviewBottomSheet extends StatelessWidget {
  CardPreviewBottomSheet(
      {super.key, required this.card, required CardsRepository cardsRepository})
      : _cardsRepository = cardsRepository;

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
                child: CardContentWidget(editorTiles: snapshot.data!));
          }
          return const Text("loading");
        },
      ),
    );
  }
}
