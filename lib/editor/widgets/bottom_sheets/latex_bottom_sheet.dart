import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:learning_app/editor/widgets/keyboard_row/new_rows/keyboard_latex_row.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/ui_components/widgets/text_fields/ui_text_field.dart';

class LatexBottomSheet extends StatefulWidget {
  LatexBottomSheet({
    super.key,
    required this.textEditingController,
    required this.latexText,
    required this.onChanged,
    required this.focusNode,
  }) {
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
      addPadding: false,
      child: Column(
        children: [
          Column(
            children: [
              Scrollbar(
                child: SingleChildScrollView(
                  reverse: true,
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
                    renderLatex('');
                    Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.defaultSize),
                  child: Scrollbar(
                    child: UITextField(
                      keyboardType: TextInputType.visiblePassword,
                      autofocus: true,
                      multiline: 5,
                      controller: widget.textEditingController,
                      style: UIText.code.copyWith(fontSize: 25),
                      onFieldSubmitted: (_) => Navigator.pop(context),
                      hintText: r'\frac{1}{2}',
                      onChanged: renderLatex,
                    ),
                  ),
                ),
              ),
            ],
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
