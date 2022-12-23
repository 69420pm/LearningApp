import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:learning_app/subject_overview/bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_draggable_tile.dart';
import 'package:ui_components/ui_components.dart';

class FolderListTile extends StatelessWidget {
  const FolderListTile({
    super.key,
    required this.folder,
    required this.cardsRepository,
  });

  final Folder folder;
  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FolderListTileBloc(cardsRepository),
      child: FolderListTileView(
        folder: folder,
      ),
    );
  }
}

class FolderListTileView extends StatefulWidget {
  const FolderListTileView({super.key, required this.folder});
  final Folder folder;

  @override
  State<FolderListTileView> createState() => _FolderListTileViewState();
}

class _FolderListTileViewState extends State<FolderListTileView> {
  @override
  Widget build(BuildContext context) {
    var childListTiles = <String, Widget>{};

    context
        .read<FolderListTileBloc>()
        .add(FolderListTileGetChildrenById(id: widget.folder.id));

    return Padding(
      padding: const EdgeInsets.only(
        bottom: UISizeConstants.defaultSize,
      ),
      child: DragTarget(
        onAccept: (data) {
          // if (data is Folder && data != folder) {
          //   context.read<FolderListTileBloc>().add(
          //         FolderListTileAddFolder(folder: data, newParentId: folder.id),
          //       );
          // } else if (data is Card) {
          //   context
          //       .read<FolderListTileBloc>()
          //       .add(FolderListTileAddCard(card: data, newParentId: folder.id));
          // }
          // TODO fix newParentId gets changed while transfering to hive_cards_api
          if (data is Folder && data != widget.folder) {
            context.read<FolderListTileBloc>().add(
                  FolderListTileMoveFolder(
                    folder: data,
                    newParentId: widget.folder.id,
                  ),
                );
          } else if (data is Card && data.parentId != widget.folder.id) {
            context
                .read<FolderListTileBloc>()
                .add(FolderListTileAddCard(card: data, newParentId: widget.folder.id));
          }
          // print(data);
          // folder.childFolders.add(data);
        },
        builder: (context, candidateData, rejectedData) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            // borderRadius: const BorderRadius.horizontal(
            //   left: Radius.circular(UISizeConstants.cornerRadius),
            // ),
            // border: Border.all(
            //   color: Theme.of(context).colorScheme.secondary,
            //   width: UISizeConstants.borderWidth,
            // ),
          ),
          child: BlocBuilder<FolderListTileBloc, FolderListTileState>(
            buildWhen: (previous, current) {
              if (current is FolderListTileRetrieveChildren) {
                return true;
              }
              return false;
            },
            builder: (context, state) {
              if (state is FolderListTileRetrieveChildren) {
                childListTiles = {...childListTiles, ...state.childrenStream};
                for (final element in state.removedWidgets) {
                  if (childListTiles.containsKey(element.id)) {
                    childListTiles.remove(element.id);
                  }
                }
              }

              return Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  controlAffinity: ListTileControlAffinity.leading,

                  collapsedTextColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
                  textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  title: Text(widget.folder.name),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => context.read<FolderListTileBloc>().add(
                              FolderListTileDeleteFolder(
                                id: widget.folder.id,
                                parentId: widget.folder.parentId,
                              ),
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.flutter_dash),
                        onPressed: () {
                          for (int i = 0; i <= 20; i++) {
                            context.read<FolderListTileBloc>().add(
                                  FolderListTileAddCard(
                                    card: Card(
                                      back: 'Servus123',
                                      front: "Moin Test lol 69420",
                                      askCardsInverted: false,
                                      id: Uid().uid(),
                                      dateCreated: '',
                                      parentId: widget.folder.id,
                                      dateToReview: DateTime.now().toIso8601String(),
                                      typeAnswer: false,
                                    ),
                                    newParentId: widget.folder.id,
                                  ),
                                );
                          }
                        },
                      ),
                      Draggable<Folder>(
                        data: widget.folder,
                        feedback: FolderDraggableTile(folder: widget.folder),
                        child: const Icon(Icons.drag_indicator),
                      )
                    ],
                  ),
                  //
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: UISizeConstants.defaultSize * 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (childListTiles.values
                              .where((element) => element is FolderListTile)
                              .isNotEmpty)
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: childListTiles.values
                                  .where((element) => element is FolderListTile)
                                  .length,
                              itemBuilder: (context, index) => childListTiles
                                  .values
                                  .where((element) => element is FolderListTile)
                                  .elementAt(index),
                            ),
                          if (childListTiles.values
                              .where((element) => element is CardListTile)
                              .isNotEmpty)
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: childListTiles.values
                                  .where((element) => element is CardListTile)
                                  .length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 3 / 1,
                                crossAxisCount: 2,
                                crossAxisSpacing: UISizeConstants.defaultSize,
                              ),
                              itemBuilder: (context, index) => childListTiles
                                  .values
                                  .where((element) => element is CardListTile)
                                  .elementAt(index),
                              // shrinkWrap: true,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
