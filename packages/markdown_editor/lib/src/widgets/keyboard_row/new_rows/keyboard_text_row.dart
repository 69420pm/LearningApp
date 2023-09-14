import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_button.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_toggle.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardTextRow extends StatefulWidget {
  const KeyboardTextRow({super.key});

  @override
  State<KeyboardTextRow> createState() => _KeyboardTextRowState();
}

class _KeyboardTextRowState extends State<KeyboardTextRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const SizedBox(
          width: 8,
        ),
        KeyboardButton(
          icon: UIIcons.add,
          onPressed: () {
            context.read<KeyboardRowCubit>().addNewTile();
          },
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 4,
              ),
              KeyboardRowContainer(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 2,
                    ),
                    KeyboardToggle(
                      icon: UIIcons.formatBold,
                      onPressed: (value) {},
                    ),
                    KeyboardToggle(
                      icon: UIIcons.formatItalic,
                      onPressed: (value) {},
                    ),
                    KeyboardToggle(
                      icon: UIIcons.formatUnderline,
                      onPressed: (value) {},
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
                    KeyboardToggle(
                      icon: UIIcons.formatColorFill,
                      onPressed: (value) {
                        context.read<KeyboardRowCubit>().expandColors();
                      },
                    ),
                    KeyboardToggle(
                      icon: UIIcons.formatColorText,
                      onPressed: (value) {
                        context.read<KeyboardRowCubit>().expandColors();
                      },
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 4,
              ),
            ],
          ),
        ),
        KeyboardButton(icon: UIIcons.account, onPressed: () {}),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }
}
