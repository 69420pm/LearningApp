import 'package:flutter/material.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';

class CalloutTile extends StatelessWidget implements EditorTile {
  CalloutTile({super.key}) {
    _textTile = TextTile(
      focusNode: focusNode,
      textStyle: TextFieldConstants.normal,
      parentEditorTile: this,
    );
  }

  late final TextTile _textTile;

  @override
  FocusNode? focusNode = FocusNode();

  @override
  TextFieldController? textFieldController;

  @override
  Widget build(BuildContext context) {
    textFieldController = _textTile.textFieldController;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              child: TextField(
                style: TextFieldConstants.calloutStart,
                maxLength: 1,
                decoration: InputDecoration(
                  isDense: true,
                  counterStyle: TextStyle(
                    height: double.minPositive,
                  ),
                  counterText: '',
                ),
              ),
            ),
            Expanded(child: _textTile),
          ],
        ),
      ),
    );
  }
}
