// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_toggle.dart';
import 'package:ui_components/ui_components.dart';

// ignore: must_be_immutable
class KeyboardLatexRow extends StatelessWidget {
  KeyboardLatexRow({super.key, required this.textEditingController});

  final TextEditingController textEditingController;

  bool isBold = false;
  bool isItalic = false;
  bool isUnderlined = false;
  final controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final tiles = [
      TextButton(
        input: r'\',
        onPressed: () {
          addChar(r"\");
        },
      ),
      TextButton(
        input: '{ }',
        onPressed: (){
          addParenthesis('{', '}');
        }
      ),
      TextButton(
        input: '( )',
        onPressed: (){
          addParenthesis('(', ')');
        }
      ),
      TextButton(
        input: '^',
        onPressed: () {
          addChar("^");
        },
      ),
      TextButton(
        input: '_',
        onPressed: () {
          addChar("_");
        },
      ),
      TextButton(
        input: '=',
        onPressed: () {
          addChar("=");
        },
      ),
      TextButton(
        input: '&',
        onPressed: () {
          addChar("&");
        },
      ),
      TextButton(
        input: '-',
        onPressed: () {
          addChar("-");
        },
      ),
      TextButton(
        input: '-',
        onPressed: () {
          addChar("-");
        },
      ),
    ];
    return Row(
      children: [
        Expanded(
          child: GridView.extent(
            shrinkWrap: true,
            primary: true,
            crossAxisSpacing: UIConstants.defaultSize,
            mainAxisSpacing: UIConstants.defaultSize * 0,
            maxCrossAxisExtent: UIConstants.defaultSize * 6,
            children: tiles,
          ),
        ),
      ],
    );
  }

  void addChar(String char) {
    final previousSelection = textEditingController.selection;
    final previousText = textEditingController.text;
    textEditingController
      ..text = previousText.substring(0, previousSelection.start) +
          char +
          previousText.substring(previousSelection.end)
      ..selection = TextSelection(
        baseOffset: previousSelection.start + 1,
        extentOffset: previousSelection.start + 1,
      );
  }

  void addParenthesis(String open, String closed) {
    final previousSelection = textEditingController.selection;
    final previousText = textEditingController.text;
    textEditingController
      ..text = previousText.substring(0, previousSelection.start) +
          open +
          previousText.substring(
              previousSelection.start, previousSelection.end) +
          closed +
          previousText.substring(previousSelection.end)
      ..selection = TextSelection(
        baseOffset: previousSelection.end + 1,
        extentOffset: previousSelection.end + 1,
      );
  }
}

class TextButton extends StatelessWidget {
  TextButton({super.key, required this.input, this.onPressed});

  String input;
  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Text(input, style: TextFieldConstants.textButton),
      onPressed: onPressed,
    );
  }
}
