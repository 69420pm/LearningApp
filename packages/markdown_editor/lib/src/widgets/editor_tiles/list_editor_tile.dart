import 'package:flutter/material.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListEditorTile extends StatelessWidget implements EditorTile {
  ListEditorTile({super.key, this.focusNode}) {
    focusNode ??= FocusNode();
    _textTile = TextTile(
      textStyle: TextFieldConstants.normal,
      isDense: true,
      contentPadding: const EdgeInsets.all(4),
      focusNode: focusNode,
      parentEditorTile: this,
    );
  }
  late final TextTile _textTile;
  @override
  FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final replacingTextTile = TextTile(
      textStyle: TextFieldConstants.normal,
    );

    textFieldController = _textTile.textFieldController;
    _textTile
      ..onSubmit = () {
        context.read<TextEditorBloc>().add(
              TextEditorAddEditorTile(
                newEditorTile: ListEditorTile(),
                context: context,
              ),
            );
      }
      ..onBackspaceDoubleClick = () {
        _textTile.focusNode = FocusNode();
        final tiles = <CharTile>[];
        _textTile.textFieldController!.charTiles.forEach((key, value) {
          tiles.add(value);
        });
        replacingTextTile.textFieldController!.addText(
          tiles,
          context,
        );
        context.read<TextEditorBloc>().add(
              TextEditorReplaceEditorTile(
                tileToRemove: this,
                newEditorTile: replacingTextTile,
                handOverText: true,
                context: context,
              ),
            );
      };
    return Row(
      children: [
        const Icon(Icons.circle, size: 10),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: _textTile)
      ],
    );
  }

  @override
  TextFieldController? textFieldController;
}
