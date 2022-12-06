import 'package:cards_api/cards_api.dart' hide Card;
import 'package:cards_repository/cards_repository.dart' hide Card;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_list_tile_bloc.dart';
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

    return Stack(
      children: [
        Draggable<Folder>(
          data: folder,
          feedback: const Text('folder'),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: const BorderRadius.all(
                Radius.circular(UISizeConstants.cornerRadius),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ExpansionTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UISizeConstants.defaultSize * 2,
                    vertical: UISizeConstants.defaultSize,
                  ),
                  child: Text(
                    'DICKHEAD',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
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
                      ...(state as FolderListTileRetrieveChildren)
                          .childrenStream
                    };
                    final childTiles = <Widget>[];
                    childListTiles
                        .forEach((key, value) => childTiles.add(value));
                    return ListView(
                      shrinkWrap: true,
                      children: childTiles,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        DragTarget<Folder>(
          onAccept: (data) {
            // print(data);
            // folder.childFolders.add(data);
          },
          builder: (context, candidateData, rejectedData) =>
              Container(width: 100, height: 10, color: Colors.blue),
        )
      ],
    );
  }
}
