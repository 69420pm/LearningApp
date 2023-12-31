import 'package:flutter/material.dart';
import 'package:learning_app/editor/models/char_tile.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/models/text_field_constants.dart';
import 'package:learning_app/editor/models/text_field_controller.dart';
import 'package:learning_app/editor/widgets/editor_tiles/text_tile.dart';

import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';

class QuoteTile extends TextTile implements EditorTile {
  QuoteTile({
    super.key,
    super.charTiles,
  }) : super(textStyle: TextFieldConstants.quote) {
    super.padding = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.pageHorizontalPadding,
      ),
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
          Expanded(child: super.build(context)),
        ],
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteTile &&
          runtimeType == other.runtimeType &&
          super.charTiles == other.charTiles &&
          focusNode == other.focusNode;
}
