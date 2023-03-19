import 'dart:ui';

import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor/src/models/rich_text_field_controller.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextTile extends StatefulWidget {
  const TextTile({super.key});

  @override
  State<TextTile> createState() => _TextTileState();
}

class _TextTileState extends State<TextTile> {
  final textFieldController = TextFieldController();
  TextSelection previousSelection = const TextSelection(
    baseOffset: 0,
    extentOffset: 0,
  );
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
        previousSelection = textFieldController.selection;
        return false;
      },
      builder: (context, state) {
        // textFieldController.buildTextSpan(
        //     context: context, withComposing: false);
        return TextField(
          controller: textFieldController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
        );
      },
    );
  }
}
