import 'package:flutter/material.dart' hide Card;
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/search_result.dart';
import 'package:learning_app/search/view/parentObjects.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/ui_label_row.dart';class FolderSearchResults extends StatelessWidget {
  FolderSearchResults({
    super.key,
    required this.foundFolders,
    this.searchRequest,
  }) {
    if (foundFolders.isNotEmpty) {
      var i = 0;
      for (final result in foundFolders) {
        widgetFolders.add(
          FolderListTileSearch(
            folder: result.searchedObject as Folder,
            searchRequest: searchRequest!,
            parentObjects: result.parentObjects,
          ),
        );
        if (i < foundFolders.length - 1) {
          widgetFolders.add(const SizedBox(height: UIConstants.itemPadding));
        }
        i++;
      }
    }
  }
  final List<SearchResult> foundFolders;
  List<Widget> widgetFolders = List.empty(growable: true);
  String? searchRequest;

  @override
  Widget build(BuildContext context) {
    if (foundFolders.isNotEmpty) {
      return Column(
        children: [
          UILabelRow(
            labelText: 'Folder',
            actionWidgets: [
              Text(
                '${foundFolders.length} Found',
                style: UIText.label.copyWith(color: UIColors.smallText),
              ),
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPadding * 1.5,
          ),
          Column(
            children: widgetFolders,
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}


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
