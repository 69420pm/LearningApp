import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/callout_tile.dart';
import 'package:ui_components/src/widgets/bottom_sheet.dart';
import 'package:ui_components/src/widgets/button.dart';
import 'package:ui_components/src/ui_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_components/src/widgets/color_picker.dart';

class MenuBottomSheet extends StatelessWidget {
  MenuBottomSheet({super.key, required this.parentEditorTile}) {
  }

  EditorTile parentEditorTile;

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
        child: Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: UIConstants.defaultSize),
      child: Column(
        children: [
          UIColorPicker(
            onColorChanged: (value) {
              final newTile = (parentEditorTile as CalloutTile).copyWith(
                  tileColor: value,
                  textTile: (parentEditorTile as CalloutTile).textTile);
              context.read<TextEditorBloc>().add(TextEditorReplaceEditorTile(
                    tileToRemove: parentEditorTile,
                    newEditorTile: newTile,
                    context: context,
                    requestFocus: false,
                  ));
              parentEditorTile = newTile;
            },
          ),
          UIButton(
            onTap: () {
              Navigator.pop(context);
              context.read<TextEditorBloc>().add(TextEditorRemoveEditorTile(
                  tileToRemove: parentEditorTile, context: context));
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.delete), Text("delete")]),
          )
        ],
      ),
    ));
  }
}
