import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/latex_text_field_controller.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/bottom_sheets/latex_bottom_sheet.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';
import 'package:flutter_math_fork/ast.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_math_fork/tex.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LatexTile extends StatelessWidget implements EditorTile {
  LatexTile({super.key, this.latexText = r"\frac{1}{2}"});

  String latexText;

  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;

  TextEditingController textEditingController = LatexTextFieldController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showModalBottomSheet<dynamic>(
          context: context,
          isScrollControlled: true,
          builder: (_) => Wrap(
            children: [
              LatexBottomSheet(
                textEditingController: textEditingController,
                latexText: latexText,
              ),
            ],
          ),
        ).whenComplete(() {
          context.read<TextEditorBloc>().add(
                TextEditorReplaceEditorTile(
                  tileToRemove: this,
                  newEditorTile:
                      this.copyWith(latexText: textEditingController.text),
                  context: context,
                ),
              );
        });
      },
      child: Center(
        child: Math.tex(
          latexText,
          textStyle: TextStyle(
              fontSize: 25, color: Theme.of(context).colorScheme.onBackground),
          onErrorFallback: (err) => Container(
            color: Colors.red,
            child: Text(
              err.messageWithType,
              style: TextStyle(color: Colors.yellow),
            ),
          ),
        ),
      ),
    ); // Default
  }

  /// copy with function of CalloutTile
  LatexTile copyWith({
    String? latexText,
  }) {
    return LatexTile(
      latexText: latexText ?? this.latexText,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatexTile &&
          runtimeType == other.runtimeType &&
          latexText == other.latexText &&
          focusNode == other.focusNode;
}
