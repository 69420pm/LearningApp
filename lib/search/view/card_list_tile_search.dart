import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/scheduler.dart';
import 'package:learning_app/search/view/parentObjects.dart';
import 'package:ui_components/ui_components.dart';

class CardListTileSearch extends StatelessWidget {
  const CardListTileSearch({
    super.key,
    required this.card,
    required this.searchRequest,
    required this.parentObjects,
  });
  final Card card;
  final String searchRequest;
  final List<Object> parentObjects;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: UIConstants.itemPadding / 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: UIConstants.itemPadding * 0.75,
            ),
            UIIcons.card,
            const SizedBox(
              width: UIConstants.itemPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(card.front, style: UIText.labelBold),
                  const SizedBox(
                    height: UIConstants.itemPadding / 4,
                  ),
                  // _HitText(searchRequest: searchRequest, text: card.front + card.back)
                  ParentObjects(
                    parentObjects: parentObjects,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: UIConstants.itemPadding,
            ),
            UIIcons.arrowForwardMedium.copyWith(color: UIColors.smallText),
          ],
        ),
        const SizedBox(
          height: UIConstants.itemPadding / 4,
        ),
      ],
    );
  }
}

// TODO finish hit text
class _HitText extends StatelessWidget {
  _HitText({super.key, required this.searchRequest, required this.text});

  String searchRequest;
  String text;

  @override
  Widget build(BuildContext context) {
    text = text + text + text + text + text + text + text;
    if (text.contains(searchRequest)) {
      text.indexOf(searchRequest);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          searchRequest,
          style: UIText.normalBold.copyWith(color: UIColors.primary),
        ),
        Flexible(
          child: Text(
            text.substring(text.indexOf(searchRequest) + 1),
            style: UIText.normal.copyWith(color: UIColors.smallText),
          ),
        ),
      ],
    );
  }
}
