// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_components/ui_components.dart';
import 'package:uuid/uuid.dart';

import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';

class FolderListTileView extends StatefulWidget {
  const FolderListTileView({
    Key? key,
    required this.isHoverd,
    required this.inSelectionMode,
    required this.folder,
    required this.childListTiles,
  }) : super(key: key);

  final bool isHoverd;
  final bool inSelectionMode;
  final Folder folder;
  final Map<String, Widget> childListTiles;

  @override
  State<FolderListTileView> createState() => _FolderListTileViewState();
}

class _FolderListTileViewState extends State<FolderListTileView> {
  @override
  Widget build(BuildContext context) {
    var isSoftSelected = widget.folder ==
        context.read<SubjectOverviewSelectionBloc>().folderSoftSelected;
    var isSelected = context
        .read<SubjectOverviewSelectionBloc>()
        .foldersSelected
        .contains(widget.folder);

    var numChilds = context
                .read<SubjectOverviewSelectionBloc>()
                .selectedInFolder[widget.folder.id] ==
            null
        ? -1
        : context
            .read<SubjectOverviewSelectionBloc>()
            .selectedInFolder[widget.folder.id]![0];
    return UIExpansionTile(
      backgroundColor: widget.isHoverd
          ? UIColors.onOverlayCard
          : isSoftSelected
              ? UIColors.overlay
              : isSelected
                  ? UIColors.overlay
                  : Colors.transparent,
      border: Border.all(
        color: widget.isHoverd
            ? Colors.transparent
            : isSelected
                ? UIColors.primary
                : Colors.transparent,
        width: UIConstants.borderWidth,
      ),
      title: Text(widget.folder.name,
          overflow: TextOverflow.ellipsis, style: UIText.label),
      iconSpacing: UIConstants.defaultSize,
      titleSpacing: UIConstants.defaultSize,
      trailing: UILinearProgressIndicator(value: 0.5),
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
    );
  }
}
