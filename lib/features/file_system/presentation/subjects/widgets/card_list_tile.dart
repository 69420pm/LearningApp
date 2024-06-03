// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/features/file_system/domain/entities/card.dart';

import 'package:learning_app/features/file_system/presentation/subjects/interfaces/file_list_tile.dart';

class CardListTile extends StatelessWidget implements FileListTile {
  final Card card;
  final void Function() onTap;
  final bool isSelected;
  const CardListTile({
    super.key,
    required this.card,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20,
        color: isSelected ? Colors.green : Colors.black,
        child: Text(card.name),
      ),
    );
  }
}
