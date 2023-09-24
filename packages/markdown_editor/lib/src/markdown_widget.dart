import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';

class MarkdownWidget extends StatelessWidget {
  MarkdownWidget({super.key});
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextEditorBloc, TextEditorState>(
      buildWhen: (previousState, currentState) =>
          currentState is TextEditorEditorTilesChanged,
      builder: (context, state) {
        final editorTiles = context.read<TextEditorBloc>().editorTiles;
        final listChildren = <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => editorTiles[index] as Widget,
                childCount: editorTiles.length),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
                [GestureDetector(
              onTap: () => context.read<TextEditorBloc>().add(TextEditorFocusLastWidget()),
                  
                  child: Container(height: 120))]),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: GestureDetector(
              onTap: () => context.read<TextEditorBloc>().add(TextEditorFocusLastWidget()),
              // child: Container(height: 120),
            ),
          )
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
