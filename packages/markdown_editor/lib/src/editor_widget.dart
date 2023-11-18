import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';

class EditorWidget extends StatelessWidget {
  EditorWidget({super.key});
  bool _firstBuild = true;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextEditorBloc, TextEditorState>(
      buildWhen: (previousState, currentState) =>
          currentState is TextEditorEditorTilesChanged,
      builder: (context, state) {
        final editorTiles = context.read<TextEditorBloc>().editorTiles;
        if (_firstBuild) {
          if (editorTiles[0] is HeaderTile &&
              ((editorTiles[0] as HeaderTile).charTiles == null ||
                  (editorTiles[0] as HeaderTile).charTiles!.isEmpty)) {
            editorTiles[0].focusNode!.requestFocus();
          }
          _firstBuild = false;
        }
        final listChildren = <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => editorTiles[index] as Widget,
              childCount: editorTiles.length,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context
                    .read<TextEditorBloc>()
                    .add(TextEditorFocusLastWidget()),
                child: Container(height: 120),
              ),
            ]),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: GestureDetector(
              onTap: () => context
                  .read<TextEditorBloc>()
                  .add(TextEditorFocusLastWidget()),
              // child: Container(height: 120),
            ),
          ),
        ];
        return CustomScrollView(
          slivers: listChildren,
        );
      },
    );
  }
}


/// # heading 1
/// ## heading 2
/// ### heading 3
/// #### heading 4
/// ##### heading 5
/// ###### heading 6
/// - / + / * unordered list
/// > quotes
/// [link] (href) links
/// ''' code '''
/// | tables | column 2
/// --- hr
/// 1. ordered list
/// $ latex
/// \** bold **
/// \* italic *
/// text color
