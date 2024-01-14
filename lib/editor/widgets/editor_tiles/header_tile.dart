import 'package:flutter/material.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/widgets/editor_tiles/text_tile.dart';

class HeaderTile extends TextTile implements EditorTile {
  HeaderTile({
    super.key,
    super.charTiles,
    super.hintText,
    required super.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        super.build(context),
      ],
    );
  }
}
