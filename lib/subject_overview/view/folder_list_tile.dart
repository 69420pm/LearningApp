import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/view/folder_draggable_tile.dart';
import 'package:ui_components/ui_components.dart';

class FolderListTile extends StatelessWidget {
  const FolderListTile(
      {super.key, required this.folder, required this.cardsRepository});

  final Folder folder;
  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FolderListTileBloc(cardsRepository),
      child: FolderListTileView(folder: folder),
    );
  }
}

class FolderListTileView extends StatelessWidget {
  const FolderListTileView({super.key, required this.folder});
  final Folder folder;
  @override
  Widget build(BuildContext context) {
    var childListTiles = <String, Widget>{};

    context
        .read<FolderListTileBloc>()
        .add(FolderListTileGetChildrenById(id: folder.id));

    return DragTarget(
      onAccept: (data) {
        // print(data);
        // folder.childFolders.add(data);
      },
      builder: (context, candidateData, rejectedData) => Draggable<Folder>(
        data: folder,
        feedback: FolderDraggableTile(folder: folder),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: const BorderRadius.all(
              Radius.circular(UISizeConstants.cornerRadius),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: UISizeConstants.defaultSize * 2),
            child: ExpansionTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                folder.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
              ),
              children: [
                BlocBuilder<FolderListTileBloc, FolderListTileState>(
                    buildWhen: (previous, current) {
                  if (current is FolderListTileRetrieveChildren) {
                    return true;
                  }
                  return false;
                }, builder: (context, state) {
                  childListTiles = {
                    ...childListTiles,
                    ...(state as FolderListTileRetrieveChildren).childrenStream
                  };

                  return ListView.builder(
                    itemCount: childListTiles.length,
                    itemBuilder: (context, index) =>
                        childListTiles.values.elementAt(index),
                    shrinkWrap: true,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
