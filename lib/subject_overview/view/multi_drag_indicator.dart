// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:ui_components/ui_components.dart';

import 'package:learning_app/subject_overview/view/card_list_tile_view.dart';

class MultiDragIndicator extends StatelessWidget {
  const MultiDragIndicator({
    super.key,
    this.cardAmount = 0,
    this.folderAmount = 0,
    this.firstCardName,
    this.firstFolderName,
  });

  final int cardAmount;
  final int folderAmount;
  final List<String>? firstCardName;
  final List<String>? firstFolderName;

  @override
  Widget build(BuildContext context) {
    var label = '';

    for (var e in firstCardName ?? firstFolderName ?? ["Error  "]) {
      label += '$e ,';
    }
    label = label.substring(0, label.length - 2);

    print(label);

    return DecoratedBox(
      decoration: BoxDecoration(
          color: UIColors.onOverlayCard,
          borderRadius: const BorderRadius.all(
            Radius.circular(UIConstants.cornerRadius),
          ),
          border: Border.all(color: UIColors.background, width: 3)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultSize * 2,
          vertical: UIConstants.defaultSize,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            AmountIndicator(amount: folderAmount, icon: UIIcons.folder),
            AmountIndicator(amount: cardAmount, icon: UIIcons.card),
            if ((folderAmount > 0 && cardAmount == 0) ||
                (cardAmount > 0 && folderAmount == 0))
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.itemPaddingLarge,
                  vertical: UIConstants.defaultSize,
                ),
                child: SizedBox(
                  width: UIConstants.defaultSize * 10,
                  child: DefaultTextStyle(
                    //* or else yellow lines below text
                    style: Theme.of(context).textTheme.bodyMedium!,
                    child: Text(label,
                        overflow: TextOverflow.ellipsis, style: UIText.label),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AmountIndicator extends StatelessWidget {
  const AmountIndicator({
    Key? key,
    required this.amount,
    required this.icon,
  }) : super(key: key);

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
              icon
            ]
          : [],
    );
  }
}
