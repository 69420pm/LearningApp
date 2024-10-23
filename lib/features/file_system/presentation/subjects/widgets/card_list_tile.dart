// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
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
    final daysToNextReview =
        card.dateToReview.difference(DateUtils.dateOnly(DateTime.now())).inDays;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: UIConstants.defaultSize),
        child: Container(
          height: UIConstants.defaultSize * 8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: const BorderRadius.all(
              Radius.circular(UIConstants.cornerRadius),
            ),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: UIConstants.borderWidth,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: UIConstants.defaultSize),
              UIIcons.card,
              const SizedBox(width: UIConstants.defaultSize),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      card.name,
                      overflow: TextOverflow.ellipsis,
                      style: UIText.label,
                    ),
                    Row(
                      children: [
                        Text(
                          daysToNextReview == null
                              ? 'finished '
                              : daysToNextReview > 1
                                  ? 'due in $daysToNextReview days'
                                  : daysToNextReview == 1
                                      ? 'due tomorrow'
                                      : 'due today',
                          overflow: TextOverflow.ellipsis,
                          style: UIText.small,
                        ),
                        const SizedBox(
                          width: UIConstants.defaultSize * 3,
                        ),
                        Text(
                          'recall score: ${card.recallScore}',
                          overflow: TextOverflow.ellipsis,
                          style: UIText.small,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
