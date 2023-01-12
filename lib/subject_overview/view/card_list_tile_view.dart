import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:ui_components/ui_components.dart';

class CardListTileView extends StatelessWidget {
  const CardListTileView({
    super.key,
    required this.card,
    this.isDragged = false,
    this.height,
    this.width,
    required this.isSelected,
    this.globalKey,
  });

  final GlobalKey? globalKey;
  final Card card;
  final bool isDragged;
  final bool isSelected;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UISizeConstants.defaultSize),
      child: Container(
        height: height,
        width: width,
        key: globalKey,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
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
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: UISizeConstants.defaultSize),
                child: Text(
                  card.front,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
