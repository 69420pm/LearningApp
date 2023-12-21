import 'package:flutter/material.dart';
import 'package:learning_app/editor/models/char_tile.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/models/text_field_constants.dart';
import 'package:learning_app/editor/models/text_field_controller.dart';
import 'package:learning_app/editor/widgets/editor_tiles/text_tile.dart';

import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class QuoteTile extends StatelessWidget implements EditorTile {
  QuoteTile({super.key, this.charTiles}) {
    _textTile = TextTile(
      focusNode: focusNode,
      textStyle: TextFieldConstants.quote,
      parentEditorTile: this,
      charTiles: charTiles,
    );
    _textTile.padding = false;
    textFieldController = _textTile.textFieldController;

  }

  late final TextTile _textTile;

  @override
  FocusNode? focusNode = FocusNode();

  @override
  TextFieldController? textFieldController;
  final Map<int, CharTile>? charTiles;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.pageHorizontalPadding,),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 25,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(child: _textTile),
        ],
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteTile &&
          runtimeType == other.runtimeType &&
          _textTile == other._textTile &&
          focusNode == other.focusNode;
}