
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';

class TextTile extends StatefulWidget implements EditorTile {
  TextTile({
    super.key,
    required this.textStyle,
    this.parentEditorTile,
    this.hintText = 'write anything',
    this.isDense,
    this.contentPadding,
    this.focusNode,
    this.onBackspaceDoubleClick,
    this.onSubmit,
  }) {
    focusNode ??= FocusNode();
    textFieldController = TextFieldController(standardStyle: textStyle);
  }

  /// TextStyle of textfield and hint text
  final TextStyle textStyle;

  /// MUST BE SET when [TextTile] is not directly
  /// the [EditorTile] that get's accessed
  final EditorTile? parentEditorTile;

  /// hint text that gets shown when the textfield is empty
  final String hintText;

  /// whether the textfield should get condensed
  final bool? isDense;

  /// contentPadding o [TextField]
  final EdgeInsetsGeometry? contentPadding;

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

  @override
  State<TextTile> createState() => _TextTileState();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextTile &&
          runtimeType == other.runtimeType &&
          textFieldController == other.textFieldController &&
          focusNode == other.focusNode;
}

class _TextTileState extends State<TextTile> {
  final FocusNode _rawKeyboardListenerNode = FocusNode();
  late TextEditorBloc _blocInstance;
  @override
  void initState() {
    widget.focusNode!.addListener(_changeFocus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _blocInstance = context.read<TextEditorBloc>();

    return BlocBuilder<TextEditorBloc, TextEditorState>(
      buildWhen: (previous, current) {
        if (current is! TextEditorKeyboardRowChanged) {
          return false;
        }
        if ((widget.textFieldController!.selection.end -
                widget.textFieldController!.selection.start) >
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
                widget.focusNode!.hasFocus &&
                widget.textFieldController!.selection.start == 0 &&
                widget.textFieldController!.selection.end == 0) {
              if (widget.onBackspaceDoubleClick != null) {
                widget.onBackspaceDoubleClick!.call();
              } else {
                context.read<TextEditorBloc>().add(
                      TextEditorRemoveEditorTile(
                        tileToRemove: widget.parentEditorTile == null
                            ? widget
                            : widget.parentEditorTile!,
                        context: context,
                        handOverText: true,
                      ),
                    );
              }
            }
          },
          child: TextField(
            controller: widget.textFieldController,
            focusNode: widget.focusNode,
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              if (widget.onSubmit != null) {
                widget.onSubmit?.call();
              } else {
                context.read<TextEditorBloc>().add(
                      TextEditorAddEditorTile(
                        newEditorTile: TextTile(
                          textStyle: TextFieldConstants.normal,
                        ),
                        context: context,
                      ),
                    );
              }
            },
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: widget.textStyle,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                isDense: widget.isDense,
                contentPadding: widget.contentPadding,),
          ),
        );
      },
    );
  }

  void _changeFocus() {
    if (widget.focusNode!.hasFocus) {
      _blocInstance.focusedTile =
          widget.parentEditorTile ?? widget;
    }
  }

  @override
  void dispose() {
    widget.focusNode!.removeListener(_changeFocus);
    super.dispose();
    // widget.focusNode!.dispose();
  }
}
