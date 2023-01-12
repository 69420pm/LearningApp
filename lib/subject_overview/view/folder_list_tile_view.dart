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
    this.isRoot = false,
  });
  final bool inSelectionMode;
  final Folder folder;
  final bool isRoot;
  final Map<String, Widget> childListTiles;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,

      collapsedTextColor: Theme.of(context).colorScheme.onSecondaryContainer,
      textColor: Theme.of(context).colorScheme.onSecondaryContainer,
      title: Text(folder.name),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => context.read<FolderListTileBloc>().add(
                  FolderListTileDeleteFolder(
                    id: folder.id,
                    parentId: folder.parentId,
                  ),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.flutter_dash),
            onPressed: () {
              for (var i = 0; i <= 20; i++) {
                context.read<FolderListTileBloc>().add(
                      FolderListTileAddCard(
                        card: Card(
                          back: 'test$i',
                          front: 'test$i',
                          askCardsInverted: false,
                          id: const Uuid().v4(),
                          dateCreated: '',
                          parentId: folder.id,
                          dateToReview: DateTime.now().toIso8601String(),
                          typeAnswer: false,
                        ),
                        newParentId: folder.id,
                      ),
                    );
              }
            },
          ),
        ],
      ),
      //
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: UISizeConstants.defaultSize * 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (childListTiles.values.whereType<FolderListTile>().isNotEmpty)
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      childListTiles.values.whereType<FolderListTile>().length,
                  itemBuilder: (context, index) => childListTiles.values
                      .whereType<FolderListTile>()
                      .elementAt(index),
                ),
              if (childListTiles.values.whereType<CardListTile>().isNotEmpty)
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      childListTiles.values.whereType<CardListTile>().length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 3 / 1,
                    crossAxisCount: 2,
                    crossAxisSpacing: UISizeConstants.defaultSize,
                  ),
                  itemBuilder: (context, index) => childListTiles.values
                      .whereType<CardListTile>()
                      .elementAt(index)
                    ..isInSelectMode = inSelectionMode,

                  // shrinkWrap: true,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
