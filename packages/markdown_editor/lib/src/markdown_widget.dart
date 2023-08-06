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
        return Container(
          height: 300,
          child: ListView.builder(
            // buildDefaultDragHandles: false,
            // onReorder: (oldIndex, newIndex) {
            //   context.read<TextEditorBloc>().add(
            //         TextEditorChangeOrderOfTile(
            //           oldIndex: oldIndex,
            //           newIndex: newIndex,
            //         ),
            //       );
            // },
            itemCount: editorTiles.length + 1,
            itemBuilder: (context, index) {
              if (index == editorTiles.length) {
                return SizedBox(
                  key: ValueKey(DateTime.now()),
                  height: 120,
                );
              }
              return editorTiles[index] as Widget;
              // return ReorderableDelayedDragStartListener(
              //   index: index,
              //   key: ValueKey(DateTime.now()),
              //   child: editorTiles[index] as Widget,
              // );
            },
            controller: ScrollController(), // Use a unique ScrollController
          ),
        );
      },
    );
  }
}

// class _ListTile extends StatelessWidget {
//   _ListTile({super.key, required this.child});
//   Widget child;
//   @override
//   Widget build(BuildContext context) {
//     return child;
//   }
// }

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
