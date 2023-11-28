import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditorReorderView extends StatelessWidget {
  const EditorReorderView({super.key});

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
              (context, index) =>
                  AbsorbPointer(child: editorTiles[index] as Widget),
              childCount: editorTiles.length,
            ),
          ),
        ];
        return ReorderableListView.builder(
            itemBuilder: (context, index) {
              return BlocProvider.value(
                key: Key(index.toString()),
                value: context.read<TextEditorBloc>(),
                child: Row(
                  children: [Expanded(child: editorTiles[index] as Widget),
                  ],
                ),
              );
            },
            itemCount: editorTiles.length,
            onReorder: (oldIndex, newIndex) {
              context.read<TextEditorBloc>().add(TextEditorChangeOrderOfTile(
                  oldIndex: oldIndex, newIndex: newIndex));
            });

        // return CustomScrollView(slivers: [
        //   SliverReorderableList(
        //       itemBuilder: (context, index) {
        //         return Text(

        //           index.toString(),
        //           key: UniqueKey());
        //         // return AbsorbPointer(
        //         //   key: UniqueKey(),
        //         //   child: editorTiles[index] as Widget,
        //         // );
        //       },
        //       itemCount: editorTiles.length,
        //       onReorder: (oldIndex, newIndex) {})
        // ]);
        // return CustomScrollView(
        //   slivers: [
        //     SliverReorderableList(
        //         itemBuilder: (context, index) {
        //           return AbsorbPointer(
        //               key: Key(index.toString()),
        //               child: editorTiles[index] as Widget);
        //         },
        //         itemCount: editorTiles.length,
        //         onReorder: (oldIndex, newIndex) {
        //           context.read<TextEditorBloc>().add(
        //               TextEditorChangeOrderOfTile(
        //                   oldIndex: oldIndex, newIndex: newIndex));
        //         })
        //   ],
        // );
      },
    );
  }
}
