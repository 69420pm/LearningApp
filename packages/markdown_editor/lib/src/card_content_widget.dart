import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:cards_repository/cards_repository.dart';

import 'package:markdown_editor/src/models/read_only_interactable.dart';

/// display card content without editing it
class CardContentWidget extends StatelessWidget {
  CardContentWidget({super.key, required this.editorTiles, required this.cardsRepository});
  CardsRepository cardsRepository;
  List<EditorTile> editorTiles;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TextEditorBloc(cardsRepository,(_) {}, editorTiles, null),
      child: Scrollbar(
        interactive: true,
        child: CustomScrollView(shrinkWrap: true, slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (editorTiles[index] is ReadOnlyInteractable) {
                  (editorTiles[index] as ReadOnlyInteractable).interactable =
                      false;
                  return editorTiles[index] as Widget;
                } else {
                  // bloc touch input, when not audio tile
                  return AbsorbPointer(
                    child: editorTiles[index] as Widget,
                  );
                }
              },
              childCount: editorTiles.length,
            ),
          ),
        ]),
      ),
    );
  }
}
