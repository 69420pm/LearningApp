import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';

class HeaderTile extends StatelessWidget implements EditorTile {
  HeaderTile({super.key, required this.headerStrength});

  /// whether it is a header1, header2, or header3 
  /// every other value except of 1, or 3 gets defaulted to 1
  int headerStrength;

  late TextFieldController _textFieldController;
  @override
  FocusNode? focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    switch (headerStrength) {
      case 1:
        _textFieldController =
            TextFieldController(standardStyle: TextFieldConstants.header1);
        break;
      case 2:
        _textFieldController =
            TextFieldController(standardStyle: TextFieldConstants.header2);
        break;
      case 3:
        _textFieldController =
            TextFieldController(standardStyle: TextFieldConstants.header3);
        break;
      default:
        _textFieldController =
            TextFieldController(standardStyle: TextFieldConstants.header1);
    }
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
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              focusNode: focusNode,
              style: _textFieldController.standardStyle,
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
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Header $headerStrength',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
