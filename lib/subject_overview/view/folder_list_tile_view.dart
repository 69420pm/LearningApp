import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';

import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';
import 'package:ui_components/ui_components.dart';
import 'package:uuid/uuid.dart';

class FolderListTileView extends StatelessWidget {
  const FolderListTileView({
    super.key,
    required this.folder,
    required this.childListTiles,
    required this.inSelectionMode,
    required this.isCardHovering,
  });
  final bool inSelectionMode;
  final Folder folder;
  final bool isCardHovering;
  final Map<String, Widget> childListTiles;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        child: Material(
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UISizeConstants.cornerRadius),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            collapsedTextColor:
                Theme.of(context).colorScheme.onSecondaryContainer,
            textColor: Theme.of(context).colorScheme.onSecondaryContainer,
            maintainState: true,
            title: Text(
              folder.name,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: PopupMenuButton<int>(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(UISizeConstants.cornerRadius),
                ),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.delete),
                      Text(
                        'delete',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.delete),
                      Text(
                        'spawn 20 cards',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ],
                  ),
                )
              ],
              onSelected: (value) async {
                if (value == 0) {
                  context.read<FolderListTileBloc>().add(
                        FolderListTileDeleteFolder(
                          id: folder.id,
                          parentId: folder.parentId,
                        ),
                      );
                } else if (value == 1) {
                  for (var i = 0; i <= 20; i++) {
                    context.read<FolderListTileBloc>().add(
                          FolderListTileDEBUGAddCard(
                            card: Card(
                              back: 'test$i',
                              front: 'test$i',
                              askCardsInverted: false,
                              id: const Uuid().v4(),
                              dateCreated: '',
                              parentId: folder.id,
                              dateToReview: DateTime.now().toIso8601String(),
                              typeAnswer: false,
                              tags: const [],
                            ),
                          ),
                        );
                    await Future.delayed(const Duration(milliseconds: 5));
                  }
                }
              },
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: UISizeConstants.defaultSize * 4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (childListTiles.values
                        .whereType<FolderListTileParent>()
                        .isNotEmpty)
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: childListTiles.values
                            .whereType<FolderListTileParent>()
                            .length,
                        itemBuilder: (context, index) {
                          return childListTiles.values
                              .whereType<FolderListTileParent>()
                              .elementAt(index);
                          // ..isHighlight = index.isOdd;
                        },
                      ),
                    if (childListTiles.values
                        .whereType<CardListTile>()
                        .isNotEmpty)
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: childListTiles.values
                            .whereType<CardListTile>()
                            .length,
                        itemBuilder: (context, index) {
                          return childListTiles.values
                              .whereType<CardListTile>()
                              .elementAt(index)
                            ..isInSelectMode = inSelectionMode;
                        },
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
