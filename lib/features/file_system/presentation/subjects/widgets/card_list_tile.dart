// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/features/file_system/domain/entities/card.dart';

import 'package:learning_app/features/file_system/presentation/subjects/interfaces/file_list_tile.dart';

class CardListTile extends StatelessWidget implements FileListTile {
  final Card card;
  final void Function() onTap;
  const CardListTile({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, child: Text(card.name));
  }
}
