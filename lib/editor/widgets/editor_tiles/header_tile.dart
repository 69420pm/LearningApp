import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/models/char_tile.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/models/text_field_controller.dart';
import 'package:learning_app/editor/widgets/editor_tiles/text_tile.dart';


class HeaderTile extends StatelessWidget implements EditorTile {
  HeaderTile({
    super.key,
    required this.textStyle,
    required this.hintText,
    this.charTiles,
  }) {
    _textTile = TextTile(
      textStyle: textStyle,
      hintText: hintText,
      focusNode: focusNode,
      parentEditorTile: this,
      charTiles: charTiles,
    );
    _textFieldController = _textTile.textFieldController!;
  }

  final TextStyle textStyle;
  final String hintText;
  late final TextTile _textTile;
  TextFieldController? _textFieldController;
  @override
  FocusNode? focusNode = FocusNode();
  final Map<int, CharTile>? charTiles;

  @override
  Widget build(BuildContext context) {
    textFieldController = _textTile.textFieldController;
    return BlocBuilder<TextEditorBloc, TextEditorState>(
      buildWhen: (previous, current) {
        if (current is! TextEditorKeyboardRowChanged) {
          return false;
        }
        if ((_textFieldController!.selection.end -
                _textFieldController!.selection.start) >
            0) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            _textTile,
          ],
        );
      },
    );
  }

  @override
  TextFieldController? textFieldController;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeaderTile &&
          runtimeType == other.runtimeType &&
          _textTile == other._textTile &&
          focusNode == other.focusNode;
}
