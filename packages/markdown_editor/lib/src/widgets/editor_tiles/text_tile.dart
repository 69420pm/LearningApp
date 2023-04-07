import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';

class TextTile extends StatelessWidget implements EditorTile {
  TextTile({
    super.key,
    required this.textStyle,
    this.parentEditorTile,
    this.hintText = 'write anything',
    this.focusNode,
  }) {
    focusNode ??= FocusNode();
    textFieldController = TextFieldController(standardStyle: textStyle);
  }

  /// TextStyle of textfield and hint text
  final TextStyle textStyle;

  /// hint text that gets shown when the textfield is empty
  final String hintText;

  /// MUST BE SET when [TextTile] is not directly the [EditorTile] that get's accessed
  final EditorTile? parentEditorTile;
  TextFieldController textFieldController =
      TextFieldController(standardStyle: TextFieldConstants.normal);
  @override
  FocusNode? focusNode;

  final FocusNode _rawKeyboardListenerNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextEditorBloc, TextEditorState>(
      buildWhen: (previous, current) {
        if (current is! TextEditorKeyboardRowChanged) {
          return false;
        }
        if ((textFieldController.selection.end -
                textFieldController.selection.start) >
            0) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return RawKeyboardListener(
          focusNode: _rawKeyboardListenerNode,
          onKey: (event) {
            if (event.isKeyPressed(LogicalKeyboardKey.backspace) &&
                focusNode!.hasFocus &&
                textFieldController.text.isEmpty) {
              context.read<TextEditorBloc>().add(TextEditorRemoveEditorTile(
                  tileToRemove:
                      parentEditorTile == null ? this : parentEditorTile!));
            }
          },
          child: TextField(
            controller: textFieldController,
            focusNode: focusNode,
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              context.read<TextEditorBloc>().add(
                    TextEditorAddEditorTile(
                      newEditorTile: TextTile(
                        textStyle: TextFieldConstants.normal,
                      ),
                      senderEditorTile:
                          parentEditorTile == null ? this : parentEditorTile!,
                    ),
                  );
            },
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: textStyle,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hintText),
          ),
        );
      },
    );
  }
}
