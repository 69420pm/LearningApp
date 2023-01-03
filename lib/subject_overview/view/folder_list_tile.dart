import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_overview_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_draggable_tile.dart';
import 'package:ui_components/ui_components.dart';
import 'package:uuid/uuid.dart';

class FolderListTile extends StatelessWidget {
  const FolderListTile({
    super.key,
    required this.folder,
    required this.cardsRepository,
    required this.editSubjectBloc,
  });

  final Folder folder;
  final CardsRepository cardsRepository;
  final EditSubjectBloc editSubjectBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FolderListTileBloc(
        cardsRepository,
        editSubjectBloc,
      ),
      child: Builder(
        builder: (context) {
          var childListTiles = <String, Widget>{};
          context
              .read<FolderListTileBloc>()
              .add(FolderListTileGetChildrenById(id: folder.id));
          return Padding(
            padding: const EdgeInsets.only(
              bottom: UISizeConstants.defaultSize,
            ),
            child: LongPressDraggable<Folder>(
              data: folder,
              feedback: FolderDraggableTile(
                folder: folder,
              ),
              childWhenDragging: Container(),
              child: DragTarget(
                onAccept: (data) {
                  // TODO fix newParentId gets changed while transfering to hive_cards_api
                  if (data is Folder && data != folder) {
                    context.read<FolderListTileBloc>().add(
                          FolderListTileMoveFolder(
                            folder: data,
                            newParentId: folder.id,
                          ),
                        );
                  } else if (data is Card && data.parentId != folder.id) {
                    context.read<FolderListTileBloc>().add(
                          FolderListTileAddCard(
                            card: data,
                            newParentId: folder.id,
                          ),
                        );
                  }
                  // print(data);
                  // folder.childFolders.add(data);
                },
                builder: (context, candidateData, rejectedData) =>
                    BlocBuilder<FolderListTileBloc, FolderListTileState>(
                  buildWhen: (previous, current) {
                    if (current is FolderListTileRetrieveChildren) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    if (state is FolderListTileRetrieveChildren) {
                      childListTiles = {
                        ...childListTiles,
                        ...state.childrenStream
                      };
                      for (final element in state.removedWidgets) {
                        if (childListTiles.containsKey(element.id)) {
                          childListTiles.remove(element.id);
                        }
                      }
                    }

                    return FolderListTileView(
                      folder: folder,
                      childListTiles: childListTiles,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FolderListTileView extends StatelessWidget {
  const FolderListTileView({
    super.key,
    required this.folder,
    required this.childListTiles,
    this.isRoot = false,
  });
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
                      .elementAt(index),
                  // shrinkWrap: true,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
