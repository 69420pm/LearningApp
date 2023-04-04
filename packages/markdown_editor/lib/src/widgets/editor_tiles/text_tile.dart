import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';

class TextTile extends StatelessWidget implements EditorTile {
  TextTile({super.key});

  final _textFieldController =
      TextFieldController(standardStyle: TextFieldConstants.normal);
  @override
  FocusNode? focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextEditorBloc, TextEditorState>(
      buildWhen: (previous, current) {
        if (current is! TextEditorKeyboardRowChanged) {
          return false;
        }
        if ((_textFieldController.selection.end -
                _textFieldController.selection.start) >
            0) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return TextField(
          focusNode: focusNode,
          controller: _textFieldController,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            context.read<TextEditorBloc>().add(
                  TextEditorAddEditorTile(
                    newEditorTile: TextTile(),
                    senderEditorTile: this,
                  ),
                );
          },
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(border: InputBorder.none, hintText: 'write anything'),
        );
      },
    );
  }
}
