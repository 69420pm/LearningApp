// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_button.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:ui_components/ui_components.dart';

// ignore: must_be_immutable
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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeyboardRowContainer(
              onBottomSheet: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  children: [
                    KeyboardButton(
                      withBackgroundColor: false,
                      icon: UIIcons.curlyBraces,
                      onPressed: () {
                        addParenthesis(r'\left\{', r'\right\}');
                      },
                    ),
                    _KeyboardTextButton(
                      text: '( )',
                      onPressed: () {
                        addParenthesis(r'\left(', r'\right)');
                      },
                    ),
                  ],
                ),
              ),
            ),
            KeyboardRowContainer(
              onBottomSheet: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  children: [
                    KeyboardButton(
                      icon: UIIcons.arrowRight,
                      withBackgroundColor: false,
                      onPressed: () => addString(
                        r'\rightarrow ',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            KeyboardRowContainer(
              onBottomSheet: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  children: [
                    _KeyboardTextButton(
                      text: '=',
                      onPressed: () {
                        addString('=');
                      },
                    ),
                  ],
                ),
              ),
            ),
            KeyboardRowContainer(
              onBottomSheet: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  children: [
                    _KeyboardTextButton(
                      text: '√',
                      onPressed: () {
                        addString(
                          r'\sqrt{}',
                          selectionStart: 6,
                          selectionEnd: 6,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            KeyboardRowContainer(
              onBottomSheet: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  children: [
                    _KeyboardTextButton(
                      text: '&',
                      onPressed: () {
                        addString('&');
                      },
                    ),
                    _KeyboardTextButton(
                      text: r'\vec',
                      onPressed: () {
                        addString(
                          r'\vec{}',
                          selectionStart: 5,
                          selectionEnd: 5,
                        );
                      },
                    ),
                    _KeyboardTextButton(
                      text: r'\frac',
                      onPressed: () {
                        addString(
                          r'\frac{numerator}{}',
                          selectionStart: 6,
                          selectionEnd: 15,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      KeyboardRowContainer(
                        onBottomSheet: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              KeyboardButton(
                                icon: UIIcons.superscript,
                                withBackgroundColor: false,
                                onPressed: () => addString('^{}',
                                    selectionStart: 2, selectionEnd: 2,),
                              ),
                              KeyboardButton(
                                icon: UIIcons.subscript,
                                withBackgroundColor: false,
                                onPressed: () => addString('_{}',
                                    selectionStart: 2, selectionEnd: 2,),
                              ),
                            ],
                          ),
                        ),
                      ),
                      KeyboardRowContainer(
                        onBottomSheet: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              KeyboardButton(
                                icon: UIIcons.spaceBar,
                                withBackgroundColor: false,
                                onPressed: () => addString(
                                  r'\ ',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      KeyboardRowContainer(
                        onBottomSheet: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              KeyboardButton(
                                icon: UIIcons.curlyBraces
                                    .copyWith(color: UIColors.smallText),
                                withBackgroundColor: false,
                                onPressed: () => addParenthesis('{', '}'),
                              ),
                              _KeyboardTextButton(
                                text: r'\',
                                onPressed: () {
                                  addString(
                                    r'\',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      KeyboardRowContainer(
                        onBottomSheet: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              KeyboardButton(
                                  icon: UIIcons.chevronLeft
                                      .copyWith(color: UIColors.smallText),
                                  withBackgroundColor: false,
                                  onPressed: () => moveCursor(-1),),
                              KeyboardButton(
                                  icon: UIIcons.chevronRight
                                      .copyWith(color: UIColors.smallText),
                                  withBackgroundColor: false,
                                  onPressed: () => moveCursor(1),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    // return Row(
    //   children: [
    //     Expanded(
    //       child: GridView.extent(
    //         shrinkWrap: true,
    //         primary: true,
    //         crossAxisSpacing: UIConstants.defaultSize,
    //         mainAxisSpacing: UIConstants.defaultSize * 0,
    //         maxCrossAxisExtent: UIConstants.defaultSize * 6,
    //         children: tiles,
    //       ),
    //     ),
    //   ],
    // );
  }

  void moveCursor(int amount) {
    final previousSelection = textEditingController.selection;
    if (previousSelection.end + amount <= textEditingController.text.length &&
        previousSelection.end + amount >= 0) {
      textEditingController.selection = TextSelection(
          baseOffset: previousSelection.end + amount,
          extentOffset: previousSelection.end + amount,);
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

class _KeyboardTextButton extends StatelessWidget {
  _KeyboardTextButton({required this.text, required this.onPressed});
  String text;
  void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: 44,
      child: Center(
        child: UIButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: UIText.code,
            textAlign: TextAlign.center,
          ),
          // onDoubleTap: onDoubleTap,
        ),
      ),
    );
  }
}
