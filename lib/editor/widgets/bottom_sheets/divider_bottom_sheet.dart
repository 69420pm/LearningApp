import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/widgets/editor_tiles/divider_tile.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/ui_components/widgets/ui_deletion_row.dart';

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
