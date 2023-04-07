import 'package:flutter/material.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarkdownWidget extends StatelessWidget {
  const MarkdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextEditorBloc, TextEditorState>(
      buildWhen: (previousState, currentState) =>
          currentState is TextEditorEditorTilesChanged,
      builder: (context, state) {
          final editorTiles = context.read<TextEditorBloc>().editorTiles;
          return Expanded(
            child: ListView.builder(
                itemCount: editorTiles.length,
                itemBuilder: (context, index) {
                  return editorTiles[index] as Widget;
                },
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
