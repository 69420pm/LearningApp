import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CardListTile extends StatelessWidget {
  const CardListTile({super.key, required this.card});

  final Card card;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(card.front));
  }
}