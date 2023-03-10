import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/view/folder_draggable_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile_view.dart';
import 'package:learning_app/subject_overview/view/folder_drag_target.dart';
import 'package:learning_app/subject_overview/view/inactive_folder_list_tile.dart';
import 'package:ui_components/ui_components.dart';

class FolderListTile extends StatelessWidget {
  FolderListTile({
    super.key,
    required this.folder,
    required this.cardsRepository,
    this.isHighlight = false,
  });

  final Folder folder;
  final CardsRepository cardsRepository;
  bool isHighlight;

  @override
  Widget build(BuildContext context) {
    // print("rebuild" + folder.name);
    var childListTiles = <String, Widget>{};
    print("rebuild" + folder.name);
    return Padding(
      padding: const EdgeInsets.only(
        bottom: UISizeConstants.defaultSize,
      ),
      child: BlocBuilder<SubjectOverviewSelectionBloc,
          SubjectOverviewSelectionState>(
        builder: (context, state) {
          return LongPressDraggable<Folder>(
            data: folder,
            feedback: FolderDraggableTile(
              folder: folder,
            ),
            maxSimultaneousDrags:
                state is SubjectOverviewSelectionModeOn ? 0 : 1,
            childWhenDragging: const PlaceholderWhileDragging(),
            child: FolderDragTarget(
              parentID: folder.id,
              child: BlocBuilder<FolderListTileBloc, FolderListTileState>(
                buildWhen: (previous, current) {
                  if (current is FolderListTileRetrieveChildren) {
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  if (state is FolderListTileRetrieveChildren) {
                    print("blocbuilder");
                    print(state.childrenStream);
                    childListTiles = {
                      ...childListTiles,
                      ...state.childrenStream
                    };
                    for (final element in state.removedWidgets) {
                      if (childListTiles.containsKey(element.id)) {
                        childListTiles.remove(element.id);
                      }
                    }

                    // var newChildListTiles = <String, Widget>{};
                    // childListTiles.forEach((key, value) {
                    //   try {
                    //     if ((value as FolderListTile).folder.parentId ==
                    //         widget.folder.id) {
                    //       newChildListTiles[value.folder.id] = value;
                    //     }
                    //   } catch (e) {
                    //     if ((value as CardListTile).card.parentId ==
                    //         widget.folder.id) {
                    //       newChildListTiles[value.card.id] = value;
                    //     }
                    //   }
                    // });
                    // childListTiles = newChildListTiles;
                  }

                  return BlocBuilder<SubjectOverviewSelectionBloc,
                      SubjectOverviewSelectionState>(
                    // buildWhen: (previous, current) => false,
                    builder: (context, state) {
                      return FolderListTileView(
                        inSelectionMode:
                            state is SubjectOverviewSelectionModeOn,
                        folder: folder,
                        childListTiles: childListTiles,
                        isHighlight: isHighlight,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
