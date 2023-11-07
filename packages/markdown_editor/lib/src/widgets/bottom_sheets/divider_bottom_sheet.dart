import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/divider_tile.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DividerBottomSheet extends StatelessWidget {
  DividerBottomSheet({super.key, required this.parentTile});
  DividerTile parentTile;
  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      child: UIDeletionRow(
        deletionText: 'Delete divider',
        onPressed: () {
          context.read<TextEditorBloc>().add(
                TextEditorRemoveEditorTile(
                  tileToRemove: parentTile,
                  context: context,
                ),
              );
              Navigator.of(context).pop();

        },
      ),
    );
  }
}
