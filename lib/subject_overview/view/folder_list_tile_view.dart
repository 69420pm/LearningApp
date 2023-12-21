// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/widgets/ui_expansion_tile.dart';class FolderListTileView extends StatelessWidget {
  const FolderListTileView({
    super.key,
    required this.folder,
    required this.childListTiles,
  });

  final Folder folder;
  final List<Widget> childListTiles;

  @override
  Widget build(BuildContext context) {
    final selectionBloc = context.read<SubjectOverviewSelectionBloc>();
    final isHovered = selectionBloc.hoveredFolderUID == folder.uid;
    final isSoftSelected = folder.uid == selectionBloc.fileSoftSelected;
    final isSelected = selectionBloc.isFileSelected(folder.uid);

    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.defaultSize),
      child: UIExpansionTile(
        changeExtentionState: isHovered,
        backgroundColor: isHovered
            ? UIColors.onOverlayCard
            : isSoftSelected || isSelected
                ? UIColors.overlay
                : Colors.transparent,
        border: Border.all(
          color: isHovered
              ? Colors.transparent
              : isSelected
                  ? UIColors.primary
                  : Colors.transparent,
          width: UIConstants.borderWidth,
        ),
        title: folder.name,
        collapsedHeight: UIConstants.defaultSize * 5,
        //trailing: UILinearProgressIndicator(value: 0.5),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: UIConstants.defaultSize * 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (childListTiles.whereType<FolderListTileParent>().isNotEmpty)
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        childListTiles.whereType<FolderListTileParent>().length,
                    itemBuilder: (context, index) {
                      return childListTiles
                          .whereType<FolderListTileParent>()
                          .elementAt(index);
                      // ..isHighlight = index.isOdd;
                    },
                  ),
                if (childListTiles.whereType<CardListTile>().isNotEmpty)
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: childListTiles.whereType<CardListTile>().length,
                    itemBuilder: (context, index) {
                      return childListTiles
                          .whereType<CardListTile>()
                          .elementAt(index);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
