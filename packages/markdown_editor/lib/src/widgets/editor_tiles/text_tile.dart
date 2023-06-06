import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';

class TextTile extends StatelessWidget implements EditorTile {
  /// constructor
  TextTile({
    super.key,
    required this.textStyle,
    this.parentEditorTile,
    this.hintText = 'write anything',
    this.isDense = true,
    this.contentPadding,
    this.focusNode,
    this.onBackspaceDoubleClick,
    this.onSubmit,
    this.isDefaultOnBackgroundTextColor = true,
  }) {
    focusNode ??= FocusNode();
    textFieldController = TextFieldController(standardStyle: textStyle);
    if (textStyle == TextFieldConstants.normal) {
      contentPadding ??= const EdgeInsets.only(top:6, bottom: 6);
    }
  }

  /// TextStyle of textfield and hint text
  final TextStyle textStyle;

  ///if true, textColor will be set to colorsScheme.onBackground and
  ///will be updated
  final bool isDefaultOnBackgroundTextColor;

  /// MUST BE SET when [TextTile] is not directly
  /// the [EditorTile] that get's accessed
  final EditorTile? parentEditorTile;

  /// hint text that gets shown when the textfield is empty
  final String hintText;

  /// whether the textfield should get condensed
  final bool? isDense;

  /// contentPadding o [TextField]
  EdgeInsetsGeometry? contentPadding;

  /// event which should get called when the backspace button
  /// get's pressed multiple times
  /// when empty the [parentEditorTile] gets deleted
  Function? onBackspaceDoubleClick;

  /// event gets fired when submit button of textfield gets pressed
  /// when empty a new textfield gets created below
  Function? onSubmit;

  /// text field controller for text field which is responsible
  /// for text formatting such as bold, italic, etc.
  @override
  TextFieldController? textFieldController =
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
        if ((textFieldController!.selection.end -
                textFieldController!.selection.start) >
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
                textFieldController!.selection.start == 0 &&
                textFieldController!.selection.end == 0) {
              if (onBackspaceDoubleClick != null) {
                onBackspaceDoubleClick!.call();
              } else {
                context.read<TextEditorBloc>().add(
                      TextEditorRemoveEditorTile(
                        tileToRemove:
                            parentEditorTile == null ? this : parentEditorTile!,
                        context: context,
                        handOverText: true,
                      ),
                    );
              }
            }
            // if(event.isKeyPressed(LogicalKeyboardKey.enter)){
            //   print("enter");
            // }
          },
          child: TextField(
            autofocus: true,
            controller: textFieldController,
            focusNode: focusNode,
            textInputAction: TextInputAction.done,
            // textfield gets pushed 80 above keyboard, that textfield
            // doesn't get hided by keyboard row, standard is 20
            scrollPadding: const EdgeInsets.all(50),
            onSubmitted: (value) {
              if (onSubmit != null) {
                onSubmit?.call();
              } else {
                context.read<TextEditorBloc>().add(
                      TextEditorAddEditorTile(
                        newEditorTile: TextTile(
                          isDefaultOnBackgroundTextColor:
                              isDefaultOnBackgroundTextColor,
                          textStyle: TextFieldConstants.normal,
                        ),
                        context: context,
                      ),
                    );
              }
            },
            onEditingComplete: () {},
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: isDefaultOnBackgroundTextColor
                ? textStyle.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)
                : textStyle,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              isDense: isDense,
              contentPadding: contentPadding,
              labelStyle: TextFieldConstants.zero,
              labelText: '',
            ),
          ),
        );
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextTile &&
          textFieldController == other.textFieldController &&
          focusNode == other.focusNode;
}
