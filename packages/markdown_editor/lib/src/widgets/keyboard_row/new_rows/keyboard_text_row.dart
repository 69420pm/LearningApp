import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_button.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_toggle.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardTextRow extends StatelessWidget {
  KeyboardTextRow({super.key, required this.isBold, required this.isItalic, required this.isUnderlined, required this.textColor, required this.backgroundColor});
  bool isBold;
  bool isItalic;
  bool isUnderlined;
  Color textColor;
  Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    final textEditorBloc = context.read<TextEditorBloc>();
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Row(
        children: [
          KeyboardButton(
            icon: UIIcons.add,
            onPressed: () {
              context.read<KeyboardRowCubit>().expandAddNewTile();
            },
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KeyboardRowContainer(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 2,
                      ),
                      KeyboardToggle(
                        icon: UIIcons.formatBold,
                        initialState: isBold,
                        onPressed: (value) {
                          textEditorBloc
                              .add(TextEditorKeyboardRowChange(isBold: value));
                        },
                      ),
                      KeyboardToggle(
                        icon: UIIcons.formatItalic,
                        initialState: isItalic,
                        onPressed: (value) {
                          textEditorBloc.add(
                            TextEditorKeyboardRowChange(isItalic: value),
                          );
                        },
                      ),
                      KeyboardToggle(
                        icon: UIIcons.formatUnderline,
                        initialState: isUnderlined,
                        onPressed: (value) {
                          textEditorBloc.add(
                            TextEditorKeyboardRowChange(isUnderlined: value),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                    ],
                  ),
                ),
                KeyboardRowContainer(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 2,
                      ),
                      KeyboardButton(
                        icon: UIIcons.formatColorFill.copyWith(
                          color: backgroundColor ==
                                  Colors.transparent
                              ? UIColors.textLight
                              : textEditorBloc.textBackgroundColor
                                  .withAlpha(255),
                        ),
                        onPressed: () {
                          if (!context
                              .read<KeyboardRowCubit>()
                              .expandedBackgroundColors) {
                            context
                                .read<KeyboardRowCubit>()
                                .expandBackgroundColors();
                          } else {
                            context.read<KeyboardRowCubit>().expandText();
                          }
                        },
                        // onDoubleTap: () {
                        //   context
                        //       .read<KeyboardRowCubit>()
                        //       .changeBackgroundColor(
                        //         Colors.transparent,
                        //         textEditorBloc,
                        //       );
                        // },
                      ),
                      KeyboardButton(
                        icon: UIIcons.formatColorText.copyWith(
                          color: textColor,
                        ),
                        onPressed: () {
                          if (!context
                              .read<KeyboardRowCubit>()
                              .expandedTextColors) {
                            context.read<KeyboardRowCubit>().expandTextColors();
                          } else {
                            context.read<KeyboardRowCubit>().expandText();
                          }
                        },
                        // onDoubleTap: () {
                        //   context.read<KeyboardRowCubit>().changeTextColor(
                        //       UIColors.textLight,
                        //       context.read<TextEditorBloc>(),);
                        //   context
                        //       .read<KeyboardRowCubit>()
                        //       .defaultTextColor(textEditorBloc);
                        // },
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          KeyboardButton(
            icon: UIIcons.done.copyWith(color: UIColors.primary),
            onPressed: () {
              // save content of card
              context.read<TextEditorBloc>().add(TextEditorNextCard(context: context));
            },
          ),
        ],
      ),
    );
  }
}
