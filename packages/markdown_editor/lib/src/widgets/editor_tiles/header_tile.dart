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
  HeaderTile({super.key, required this.textStyle, required this.hintText});

  final TextStyle textStyle;
  final String hintText;

  late TextFieldController _textFieldController;
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
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextTile(
              textStyle: textStyle,
              hintText: hintText,
              focusNode: focusNode,
              parentEditorTile: this,
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
