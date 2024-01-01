import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/models/char_tile.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/models/text_field_constants.dart';
import 'package:learning_app/editor/models/text_field_controller.dart';
import 'package:learning_app/editor/widgets/editor_tiles/text_tile.dart';

import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';

class ListEditorTile extends StatelessWidget implements EditorTile {
  ListEditorTile(
      {super.key,
      this.orderNumber = 0,
      TextTile? textTile,
      this.charTiles,
      this.inRenderMode = false}) {
    _textTile = textTile ??
        TextTile(
          textStyle: TextFieldConstants.normal,
          focusNode: focusNode,
          parentEditorTile: this,
          charTiles: charTiles,
        );
    _textTile.padding = false;
    focusNode = _textTile.focusNode;
    textFieldController = _textTile.textFieldController;
  }

  final Map<int, CharTile>? charTiles;
  late final TextTile _textTile;
  int orderNumber;

  @override
  FocusNode? focusNode = FocusNode();

  @override
  TextFieldController? textFieldController;

  @override
  bool inRenderMode;

  @override
  Widget build(BuildContext context) {
    final replacingTextTile = TextTile(
      textStyle: TextFieldConstants.normal,
    );

    _textTile
      ..onSubmit = () {
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
          Expanded(child: _textTile),
        ],
      ),
    );
  }

  ListEditorTile copyWith({int? orderNumber, TextTile? textTile}) {
    return ListEditorTile(
      orderNumber: orderNumber ?? this.orderNumber,
      textTile: textTile ?? _textTile,
    );
  }
}
