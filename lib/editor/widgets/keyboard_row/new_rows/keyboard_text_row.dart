import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/cubit/keyboard_row_cubit.dart';
import 'package:learning_app/editor/widgets/keyboard_row/keyboard_button.dart';
import 'package:learning_app/editor/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:learning_app/editor/widgets/keyboard_row/keyboard_toggle.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_icons.dart';

class KeyboardTextRow extends StatelessWidget {
  KeyboardTextRow(
      {super.key,
      required this.isBold,
      required this.isItalic,
      required this.isUnderlined,
      required this.textColor,
      required this.backgroundColor});
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
                        toggled: isBold,
                        onPressed: (value) {
                          textEditorBloc
                              .add(TextEditorKeyboardRowChange(isBold: value));
                        },
                      ),
                      KeyboardToggle(
                        icon: UIIcons.formatItalic,
                        toggled: isItalic,
                        onPressed: (value) {
                          textEditorBloc.add(
                            TextEditorKeyboardRowChange(isItalic: value),
                          );
                        },
                      ),
                      KeyboardToggle(
                        icon: UIIcons.formatUnderline,
                        toggled: isUnderlined,
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
                          color: backgroundColor == Colors.transparent
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
              context
                  .read<TextEditorBloc>()
                  .add(TextEditorNextCard(context: context));
            },
          ),
        ],
      ),
    );
  }
}
