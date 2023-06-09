import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';
import 'package:flutter_math_fork/ast.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_math_fork/tex.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LatexTile extends StatelessWidget implements EditorTile {
  LatexTile({super.key}) {
    _textTile = TextTile(
      focusNode: focusNode,
      textStyle: TextFieldConstants.quote,
      parentEditorTile: this,
    );
  }

  late final TextTile _textTile;

  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;

  @override
  Widget build(BuildContext context) {
    textFieldController = _textTile.textFieldController;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap:(){
        context.read<KeyboardRowCubit>().expandLatex();
      },
      child: Center(
        child: Math.tex(
          r'f(x) = \int_{-\infty}^\infty f\hat \xi\,e^{2 \pi i \xi x}\,d\xi',
          mathStyle: MathStyle.display,
          textStyle: TextStyle(fontSize: 25),
          onErrorFallback: (err) => Container(
            color: Colors.red,
            child:
                Text(err.messageWithType, style: TextStyle(color: Colors.yellow)),
          ),
        ),
      ),
    ); // Default
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatexTile &&
          runtimeType == other.runtimeType &&
          _textTile == other._textTile &&
          focusNode == other.focusNode;
}
