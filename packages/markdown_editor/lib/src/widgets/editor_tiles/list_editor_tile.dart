import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';

class ListEditorTile extends StatelessWidget implements EditorTile {
  /// initialize ListEditorTile
  ListEditorTile({super.key, this.orderNumber = 0, TextTile? textTile}) {
    _textTile = textTile ??
        TextTile(
          textStyle: TextFieldConstants.normal,
          isDense: true,
          contentPadding: const EdgeInsets.all(4),
          focusNode: focusNode,
          parentEditorTile: this,
        );
    focusNode = _textTile.focusNode;
    textFieldController = _textTile.textFieldController;
  }
  late final TextTile _textTile;
  int orderNumber;
  @override
  FocusNode? focusNode = FocusNode();

  @override
  TextFieldController? textFieldController;

  @override
  Widget build(BuildContext context) {
    final replacingTextTile = TextTile(
      textStyle: TextFieldConstants.normal,
    );

    _textTile
      ..onSubmit = () {
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
        if (orderNumber == 0)
          const Icon(Icons.circle, size: 10)
        else
          Text(
            orderNumber.toString(),
            style: TextFieldConstants.orderedListIndex,
          ),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: _textTile)
      ],
    );
  }

  ListEditorTile copyWith({int? orderNumber, TextTile? textTile}) {
    return ListEditorTile(
      orderNumber: orderNumber ?? this.orderNumber,
      textTile: textTile ?? _textTile,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListEditorTile &&
          runtimeType == other.runtimeType &&
          _textTile == other._textTile &&
          orderNumber == other.orderNumber &&
          focusNode == other.focusNode;

}
