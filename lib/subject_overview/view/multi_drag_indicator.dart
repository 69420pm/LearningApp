// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:ui_components/ui_components.dart';

class MultiDragIndicator extends StatelessWidget {
  const MultiDragIndicator({
    super.key,
    required this.fileUIDs,
    required this.cardsRepository,
  });

  final List<String> fileUIDs;
  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    final folderUIDs = fileUIDs
        .where((uid) => cardsRepository.objectFromId(uid) is Folder)
        .toList();
    final cardUIDs = fileUIDs
        .where((uid) => cardsRepository.objectFromId(uid) is Card)
        .toList();

    var folderLabel = '';
    for (var i = 0; i < folderUIDs.length; i++) {
      if (i > 0) folderLabel += ', ';
      folderLabel +=
          (cardsRepository.objectFromId(folderUIDs[i]) as Folder).name;
    }

    var cardsLabel = '';
    for (var i = 0; i < cardUIDs.length; i++) {
      if (i > 0) cardsLabel += ', ';
      cardsLabel += (cardsRepository.objectFromId(cardUIDs[i]) as Card).name;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: UIColors.onOverlayCard,
        borderRadius: const BorderRadius.all(
          Radius.circular(UIConstants.cornerRadius),
        ),
        border: Border.all(color: UIColors.background, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultSize * 2,
          vertical: UIConstants.defaultSize,
        ),
        child: Column(
          children: [
            if (folderUIDs.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AmountIndicator(
                      amount: folderUIDs.length, icon: UIIcons.folder),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.itemPaddingLarge,
                      vertical: UIConstants.defaultSize,
                    ),
                    child: SizedBox(
                      width: UIConstants.defaultSize * 10,
                      child: DefaultTextStyle(
                        style: UIText.normal,
                        child: Text(
                          folderLabel,
                          overflow: TextOverflow.ellipsis,
                          style: UIText.label,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (cardUIDs.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AmountIndicator(amount: cardUIDs.length, icon: UIIcons.card),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.itemPaddingLarge,
                      vertical: UIConstants.defaultSize,
                    ),
                    child: SizedBox(
                      width: UIConstants.defaultSize * 10,
                      child: DefaultTextStyle(
                        style: UIText.normal,
                        child: Text(
                          cardsLabel,
                          overflow: TextOverflow.ellipsis,
                          style: UIText.label,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class AmountIndicator extends StatelessWidget {
  const AmountIndicator({
    super.key,
    required this.amount,
    required this.icon,
  });

  final int amount;
  final UIIcon icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: amount > 0
          ? [
              if (amount > 1)
                DefaultTextStyle(
                  //* or else yellow lines below text
                  style: Theme.of(context).textTheme.bodyMedium!,
                  child: Text(
                    amount.toString(),
                    style: UIText.label,
                  ),
                ),
              if (amount > 1)
                const SizedBox(width: UIConstants.itemPaddingSmall),
              icon,
            ]
          : [],
    );
  }
}
