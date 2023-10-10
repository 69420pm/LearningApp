import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/new_rows/keyboard_latex_row.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_math_fork/ast.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/tex.dart';

class LatexBottomSheet extends StatefulWidget {
  LatexBottomSheet(
      {super.key,
      required this.textEditingController,
      required this.latexText,
      required this.onChanged,
      required this.focusNode}) {
    textEditingController.text = latexText;
  }

  TextEditingController textEditingController = TextEditingController();
  String latexText;
  FocusNode focusNode;
  void Function(String) onChanged;
  @override
  State<LatexBottomSheet> createState() => _LatexBottomSheetState();
}

class _LatexBottomSheetState extends State<LatexBottomSheet> {
  void renderLatex(String text) {
    setState(() {
      widget.latexText = text;
    });
    widget.onChanged(text);
  }

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      addPadding: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.pageHorizontalPadding,
            ),
            child: Column(
              children: [
                //TODO fix scrollbar
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Math.tex(
                    widget.latexText,
                    textStyle: const TextStyle(fontSize: 25),
                    onErrorFallback: (err) => Text(
                      err.messageWithType,
                      style: UIText.code.copyWith(color: UIColors.delete),
                    ),
                  ),
                ),
                const SizedBox(
                  height: UIConstants.itemPaddingLarge,
                ),
                RawKeyboardListener(
                  focusNode: widget.focusNode,
                  onKey: (event) {
                    if (event.isKeyPressed(LogicalKeyboardKey.backspace) &&
                        widget.focusNode.hasFocus &&
                        widget.textEditingController.selection.start == 0 &&
                        widget.textEditingController.selection.end == 0) {
                          renderLatex("");
                          Navigator.of(context).pop();
                        }
                  },
                  child: UITextField(
                    autofocus: true,
                    multiline: null,
                    controller: widget.textEditingController,
                    style: UIText.code,
                    onFieldSubmitted: (_) => Navigator.pop(context),
                    hintText: r'\frac{1}{2}',
                    onChanged: renderLatex,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          KeyboardLatexRow(
            textEditingController: widget.textEditingController,
            updateLatex: renderLatex,
          ),
        ],
      ),
    );
  }
}
