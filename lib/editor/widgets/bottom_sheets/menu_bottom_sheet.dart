import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/widgets/editor_tiles/callout_tile.dart';
import 'package:ui_components/src/widgets/color_picker.dart';

class MenuBottomSheet extends StatelessWidget {
  MenuBottomSheet({super.key, required this.parentEditorTile});

  EditorTile parentEditorTile;

  @override
  Widget build(BuildContext context) {
    return UIColorPicker(
      onColorChanged: (color, isDefaultColor) {
        final newTile = (parentEditorTile as CalloutTile).copyWith(
          tileColor: color,
          textTile: (parentEditorTile as CalloutTile).textTile,
        );
        context.read<TextEditorBloc>().add(
              TextEditorReplaceEditorTile(
                tileToRemove: parentEditorTile,
                newEditorTile: newTile,
                context: context,
                requestFocus: false,
              ),
            );
        parentEditorTile = newTile;
      },
    );
  }
}


//UIButton(
        //   onTap: () {
        //     Navigator.pop(context);
        //     context.read<TextEditorBloc>().add(TextEditorRemoveEditorTile(
        //         tileToRemove: parentEditorTile, context: context));
        //   },
        //   child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [Icon(Icons.delete), Text("delete")]),
        // )
