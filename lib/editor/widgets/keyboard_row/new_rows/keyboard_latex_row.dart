// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:learning_app/editor/widgets/keyboard_row/keyboard_button.dart';
import 'package:learning_app/editor/widgets/keyboard_row/keyboard_latex_button.dart';
import 'package:learning_app/editor/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_button.dart'; // ignore: must_be_immutable

class KeyboardLatexRow extends StatelessWidget {
  KeyboardLatexRow({
    super.key,
    required this.textEditingController,
    required this.updateLatex,
  });

  final TextEditingController textEditingController;

  bool isBold = false;
  bool isItalic = false;
  bool isUnderlined = false;
  final controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  void Function(String) updateLatex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: UIConstants.defaultSize,
          runSpacing: UIConstants.defaultSize,
          children: [
            KeyboardLatexButton(
              text: "+",
              onPressed: () => addString(
                '+',
              ),
            ),

            KeyboardLatexButton(
              text: "-",
              onPressed: () => addString(
                '-',
              ),
            ),
            KeyboardLatexButton(
              text: "*",
              onPressed: () => addString(
                '*',
              ),
            ),
            KeyboardLatexButton(
              text: "/",
              onPressed: () => addString(
                '/',
              ),
            ),
            KeyboardLatexButton(
              text: '=',
              onPressed: () {
                addString('=');
              },
            ),
            KeyboardLatexButton(
              text: '( )',
              onPressed: () {
                addParenthesis(r'\left( ', r' \right)');
              },
            ),
            KeyboardLatexButton(
              icon: UIIcons.curlyBraces,
              onPressed: () {
                addParenthesis(r'\left\{ ', r' \right\}');
              },
            ),
            //
            //
            // KeyboardLatexButton(
            //   text: '&',
            //   onPressed: () {
            //     addString('&');
            //   },
            // ),
            //
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          spacing: UIConstants.defaultSize,
          runSpacing: UIConstants.defaultSize,
          children: [
            KeyboardLatexButton(
              icon: UIIcons.superscript,
              onPressed: () => addString(
                '^{}',
                selectionStart: 2,
                selectionEnd: 2,
              ),
            ),
            KeyboardLatexButton(
              icon: UIIcons.subscript,
              onPressed: () => addString(
                '_{}',
                selectionStart: 2,
                selectionEnd: 2,
              ),
            ),
            KeyboardLatexButton(
              text: '√',
              onPressed: () {
                addString(
                  r'\sqrt{}',
                  selectionStart: 6,
                  selectionEnd: 6,
                );
              },
            ),
            KeyboardLatexButton(
              text: "f",
              onPressed: () {
                addString(
                  r'\frac{}{}',
                  selectionStart: 6,
                  selectionEnd: 6,
                );
              },
            ),
            KeyboardLatexButton(
              text: "v",
              onPressed: () {
                addString(
                  r'\vec{}',
                  selectionStart: 5,
                  selectionEnd: 5,
                );
              },
            ),
            KeyboardLatexButton(
              icon: UIIcons.arrowRight,
              onPressed: () => addString(
                r'\rightarrow ',
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          spacing: UIConstants.defaultSize,
          runSpacing: UIConstants.defaultSize,
          children: [
            KeyboardLatexButton(
              icon: UIIcons.curlyBraces.copyWith(color: UIColors.smallText),
              onPressed: () => addParenthesis('{', '}'),
            ),
            KeyboardLatexButton(
              text: r'\',
              onPressed: () {
                addString(
                  r'\',
                );
              },
            ),
            KeyboardLatexButton(
              icon: UIIcons.chevronLeft.copyWith(color: UIColors.smallText),
              onPressed: () => moveCursor(-1),
            ),
            KeyboardLatexButton(
              icon: UIIcons.chevronRight.copyWith(color: UIColors.smallText),
              onPressed: () => moveCursor(1),
            ),
          ],
        ),
      ],
    );
  }

  void moveCursor(int amount) {
    final previousSelection = textEditingController.selection;
    if (previousSelection.end + amount <= textEditingController.text.length &&
        previousSelection.end + amount >= 0) {
      textEditingController.selection = TextSelection(
        baseOffset: previousSelection.end + amount,
        extentOffset: previousSelection.end + amount,
      );
      updateLatex(textEditingController.text);
    }
  }

  void addParenthesis(String open, String closed) {
    final previousSelection = textEditingController.selection;
    final previousText = textEditingController.text;
    textEditingController
      ..text = previousText.substring(0, previousSelection.start) +
          open +
          previousText.substring(
            previousSelection.start,
            previousSelection.end,
          ) +
          closed +
          previousText.substring(previousSelection.end)
      ..selection = TextSelection(
        baseOffset: previousSelection.end + open.length,
        extentOffset: previousSelection.end + open.length,
      );
    updateLatex(textEditingController.text);
  }

  void addString(String command, {int? selectionStart, int? selectionEnd}) {
    selectionStart ??= command.length;
    selectionEnd ??= command.length;
    final previousSelection = textEditingController.selection;
    final previousText = textEditingController.text;
    textEditingController
      ..text = previousText.substring(0, previousSelection.start) +
          command +
          previousText.substring(previousSelection.end)
      ..selection = TextSelection(
        baseOffset: previousSelection.start + selectionStart,
        extentOffset: previousSelection.start + selectionEnd,
      );
    updateLatex(textEditingController.text);
  }
}
