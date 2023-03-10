import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';

class FolderListTileParent extends StatelessWidget {
  FolderListTileParent(
      {super.key,
      required this.cardsRepository,
      required this.folder,
      required this.isHighlight});
  CardsRepository cardsRepository;
  Folder folder;
  bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FolderListTileBloc(cardsRepository),
      child: Builder(
        builder: (context) {
          context
              .read<FolderListTileBloc>()
              .add(FolderListTileGetChildrenById(id: folder.id));
          return FolderListTile(
            folder: folder,
            cardsRepository: cardsRepository,
            isHighlight: isHighlight,
          );
        },
      ),
    );
  }
}
