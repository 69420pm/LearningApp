import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/models/char_tile.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/models/text_field_constants.dart';
import 'package:learning_app/editor/widgets/editor_tiles/text_tile.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';

class ListEditorTile extends TextTile implements EditorTile {
  ListEditorTile({super.key, this.orderNumber = 0, super.charTiles})
      : super(textStyle: TextFieldConstants.normal, padding: false);

  int orderNumber;

  @override
  Widget build(BuildContext context) {
    final replacingTextTile = TextTile(
      textStyle: TextFieldConstants.normal,
    );

    super.onSubmit = () {
      if (textFieldController != null && textFieldController!.text.isEmpty) {
        context.read<TextEditorBloc>().add(
              TextEditorReplaceEditorTile(
                tileToRemove: this,
                newEditorTile: TextTile(
                  key: ValueKey(DateTime.now()),
                  textStyle: TextFieldConstants.normal,
                ),
                context: context,
              ),
            );
      } else {
        context.read<TextEditorBloc>().add(
              orderNumber == 0
                  ? TextEditorAddEditorTile(
                      newEditorTile: ListEditorTile(),
                      context: context,
                    )
                  : TextEditorAddEditorTile(
                      newEditorTile: ListEditorTile(
                        orderNumber: orderNumber + 1,
                      ),
                      context: context,
                    ),
            );
      }
    };
    super.onBackspaceDoubleClick = () {
      super.focusNode = FocusNode();
      final tiles = <CharTile>[];
      super.textFieldController!.charTiles.forEach((key, value) {
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
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.pageHorizontalPadding),
      child: Row(
        children: [
          const SizedBox(
            width: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: orderNumber == 0
                ? UIIcons.circle
                : Text(
                    '$orderNumber.',
                    style: TextFieldConstants.orderedListIndex,
                  ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(child: super.build(context)),
        ],
      ),
    );
  }

  ListEditorTile copyWith({int? orderNumber, TextTile? textTile}) {
    return ListEditorTile(
      orderNumber: orderNumber ?? this.orderNumber,
    );
  }
}
