import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_bloc/subject_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/dragging_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile_view.dart';
import 'package:learning_app/subject_overview/view/inactive_list_tile.dart';

import '../bloc/folder_bloc/folder_list_tile_bloc.dart';
import '../bloc/selection_bloc/subject_overview_selection_bloc.dart';

class FolderListTileParent extends StatelessWidget {
  FolderListTileParent({
    super.key,
    required this.folder,
    required this.cardsRepository,
  });

  final Folder folder;
  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context
          .read<SubjectBloc>()
          .cardsRepository
          .getChildrenById(folder.uid),
      builder: (context, value, child) {
        return BlocBuilder<SubjectOverviewSelectionBloc,
            SubjectOverviewSelectionState>(
          builder: (context, state) {
            return BlocBuilder<FolderListTileBloc, FolderListTileState>(
              buildWhen: (previous, current) =>
                  current is FolderListTileSuccess,
              builder: (context, state) {
                final isDraggedInMultiSelection = context
                        .read<SubjectOverviewSelectionBloc>()
                        .isInSelectMode &&
                    context.read<SubjectOverviewSelectionBloc>().isInDragging &&
                    context
                        .read<SubjectOverviewSelectionBloc>()
                        .isFileSelected(folder.uid);
                if (isDraggedInMultiSelection) {
                  return const InactiveListTile();
                } else {
                  return DraggingTile(
                    fileUID: folder.uid,
                    cardsRepository: cardsRepository,
                    child: FolderListTileView(
                      folder: folder,
                      childListTiles: value.map((e) {
                        if (e is Folder) {
                          return FolderListTileParent(
                              folder: e, cardsRepository: cardsRepository);
                        } else {
                          return CardListTile(
                            card: e as Card,
                            cardsRepository: cardsRepository,
                          );
                        }
                      }).toList(),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
