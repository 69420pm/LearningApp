import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/card_backend/cards_repository.dart';

/// display card content without editing it
//Todo make it like the learning Screen
class CardContentWidget extends StatelessWidget {
  CardContentWidget(
      {super.key, required this.editorTiles, required this.cardsRepository});
  CardsRepository cardsRepository;
  List<EditorTile> editorTiles;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TextEditorBloc(cardsRepository, (_) {}, editorTiles, null),
      child: Scrollbar(
        interactive: true,
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  editorTiles[index].inRenderMode = false;
                  return editorTiles[index] as Widget;
                },
                childCount: editorTiles.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
