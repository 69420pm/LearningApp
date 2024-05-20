// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/features/folder_system/domain/entities/card.dart';

import 'package:learning_app/features/folder_system/presentation/subjects/interfaces/file_list_tile.dart';

class CardListTile extends StatelessWidget implements FileListTile {
  final Card card;
  const CardListTile({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Text(card.name);
  }
}
