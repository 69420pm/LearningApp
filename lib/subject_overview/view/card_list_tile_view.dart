import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:ui_components/ui_components.dart';

class CardListTileView extends StatelessWidget {
  CardListTileView({
    super.key,
    required this.card,
    required this.isSelected,
  });

  final Card card;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.defaultSize),
      child: Container(
        height: UIConstants.defaultSize * 5,
        decoration: BoxDecoration(
          color: isSelected ? UIColors.overlay : Colors.transparent,
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
        child: Padding(
          padding: const EdgeInsets.only(left: UIConstants.defaultSize),
          child: Row(
            children: [
              UIIcons.card,
              const SizedBox(width: UIConstants.defaultSize * 2),
              Expanded(
                child: Text(
                  '${card.name}', // card.front,
                  overflow: TextOverflow.ellipsis,
                  style: UIText.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
