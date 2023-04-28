import 'dart:math';

import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:ui_components/ui_components.dart';

class CardListTileView extends StatelessWidget {
  CardListTileView({
    super.key,
    required this.card,
    this.isChildWhenDragging = false,
    this.height,
    this.width,
    required this.isSelected,
    this.globalKey,
  });

  final GlobalKey? globalKey;
  final Card card;
  final bool isChildWhenDragging;
  final bool isSelected;
  final double? height;
  final double? width;

  final List<Color> colors = [
    Colors.red,
    Colors.deepOrange,
    Colors.orange,
    Colors.lime,
    Colors.lightGreen,
    Colors.green,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UISizeConstants.defaultSize),
      child: Container(
        height: UISizeConstants.defaultSize * 5,
        width: width,
        key: globalKey,
        decoration: BoxDecoration(
          color: isChildWhenDragging
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
              : Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(
            Radius.circular(UISizeConstants.cornerRadius),
          ),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: UISizeConstants.borderWidth,
          ),
        ),
        child: Row(
          children: !isChildWhenDragging
              ? [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: UISizeConstants.defaultSize * 2,
                        vertical: UISizeConstants.defaultSize),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: colors[card.recallScore],
                        ),
                        const SizedBox(width: UISizeConstants.defaultSize * 2),
                        Text(
                          card.front,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}
