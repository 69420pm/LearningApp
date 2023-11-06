import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/search/view/parentObjects.dart';
import 'package:ui_components/ui_components.dart';

class FolderListTileSearch extends StatelessWidget {
  const FolderListTileSearch({
    super.key,
    required this.folder,
    required this.searchRequest,
    required this.parentObjects,
  });
  final Folder folder;
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
            UIIcons.folder,
            const SizedBox(
              width: UIConstants.itemPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(folder.name, style: UIText.labelBold),
                  const SizedBox(
                    height: UIConstants.itemPadding / 4,
                  ),
                  ParentObjects(
                    parentObjects: parentObjects,
                  ),
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
