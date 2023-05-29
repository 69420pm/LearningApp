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
        final editorTiles = context.watch<TextEditorBloc>().editorTiles;
        return Expanded(
          child: Scrollbar(
            thickness: 10,
            interactive: true,
            child: ListView.builder(
              itemCount: editorTiles.length,
              itemBuilder: (context, index) {
                return editorTiles[index] as Widget;
              },
              controller: ScrollController(), // Use a unique ScrollController
            ),
          ),
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
