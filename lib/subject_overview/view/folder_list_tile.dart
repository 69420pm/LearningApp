import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_overview_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_draggable_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile_view.dart';
import 'package:ui_components/ui_components.dart';
import 'package:uuid/uuid.dart';

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
      create: (context) => FolderListTileBloc(
        cardsRepository,
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
                      } else if (data is Card) {
                        print("drag to select");
                        context.read<SubjectOverviewSelectionBloc>().add(
                            SubjectOverviewSelectionToggleSelectMode(
                                inSelectMode: true));
                        context.read<SubjectOverviewSelectionBloc>().add(
                            SubjectOverviewSelectionChange(
                                card: data, addCard: true));
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

                        return BlocBuilder<SubjectOverviewSelectionBloc,
                            SubjectOverviewSelectionState>(
                          builder: (context, state) {
                            return FolderListTileView(
                              inSelectionMode:
                                  state is SubjectOverviewSelectionModeOn,
                              folder: folder,
                              childListTiles: childListTiles,
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
        },
      ),
    );
  }
}
