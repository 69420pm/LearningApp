import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListEditorTile extends StatelessWidget implements EditorTile {
  /// initialize ListEditorTile
  ListEditorTile(
      {super.key, this.orderNumber = 0, this.textTile, this.focusNode}) {
    _textTile = textTile ??
        TextTile(
          textStyle: TextFieldConstants.normal,
          isDense: true,
          contentPadding: const EdgeInsets.all(4),
          focusNode: focusNode ?? FocusNode(),
          parentEditorTile: this,
        );
    focusNode = _textTile.focusNode;
  }
  late final TextTile _textTile;
  int orderNumber;
  TextTile? textTile;
  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;

  @override
  Widget build(BuildContext context) {
    final replacingTextTile = TextTile(
      textStyle: TextFieldConstants.normal,
    );

    // textFieldController = _textTile.textFieldController;
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

  ListEditorTile copyWith(
      {int? orderNumber, TextTile? textTile}) {
    return ListEditorTile(
      orderNumber: orderNumber ?? this.orderNumber,
      textTile: textTile ?? _textTile,
    );
  }

  @override
  List<Object?> get props => [orderNumber, focusNode];

  @override
  bool? get stringify => true;
}
