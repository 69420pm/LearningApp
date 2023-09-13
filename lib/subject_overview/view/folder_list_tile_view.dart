import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';

import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';
import 'package:ui_components/ui_components.dart';
import 'package:uuid/uuid.dart';

class FolderListTileView extends StatefulWidget {
  const FolderListTileView({
    super.key,
    required this.folder,
    required this.childListTiles,
    required this.inSelectionMode,
    required this.isHoverd,
  });

  final bool isHoverd;
  final bool inSelectionMode;
  final Folder folder;
  final Map<String, Widget> childListTiles;

  @override
  State<FolderListTileView> createState() => _FolderListTileViewState();
}

class _FolderListTileViewState extends State<FolderListTileView> {
  bool isSoftSelected = false;
  @override
  Widget build(BuildContext context) {
    isSoftSelected = widget.folder.parentId ==
        context.read<SubjectOverviewSelectionBloc>().folderSoftSelected;
    return GestureDetector(
      onLongPress: () => print("long"),
      onTap: () {
        if (!widget.inSelectionMode) {
          context.read<SubjectOverviewSelectionBloc>().add(
              SubjectOverviewSetSoftSelectFolder(
                  folder: isSoftSelected ? null : widget.folder.parentId));
        }
      },
      child: UIExpansionTile(
        backgroundColor: widget.isHoverd
            ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2)
            : isSoftSelected
                ? Colors.red
                : Colors.transparent,
        border: Border.all(
          color: widget.isHoverd
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: UIConstants.borderWidth,
        ),
        title: Text(widget.folder.name,
            overflow: TextOverflow.ellipsis, style: UIText.label),
        iconSpacing: UIConstants.defaultSize,
        titleSpacing: UIConstants.defaultSize,
        trailing: UILinearProgressIndicator(value: 0.5),
        /* PopupMenuButton<int>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(UIConstants.cornerRadius),
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
                      id: widget.folder.id,
                      parentId: widget.folder.parentId,
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
                          parentId: widget.folder.id,
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
        ), */
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: UIConstants.defaultSize * 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.childListTiles.values
                    .whereType<FolderListTileParent>()
                    .isNotEmpty)
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.childListTiles.values
                        .whereType<FolderListTileParent>()
                        .length,
                    itemBuilder: (context, index) {
                      return widget.childListTiles.values
                          .whereType<FolderListTileParent>()
                          .elementAt(index);
                      // ..isHighlight = index.isOdd;
                    },
                  ),
                if (widget.childListTiles.values
                    .whereType<CardListTile>()
                    .isNotEmpty)
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.childListTiles.values
                        .whereType<CardListTile>()
                        .length,
                    itemBuilder: (context, index) {
                      return widget.childListTiles.values
                          .whereType<CardListTile>()
                          .elementAt(index)
                        ..isInSelectMode = widget.inSelectionMode;
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color getBackgroundColor(bool isHoverd, BuildContext context) {
    if (isHoverd == true) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.2);
    } else {
      return Theme.of(context).colorScheme.background;
    }
  }
}
