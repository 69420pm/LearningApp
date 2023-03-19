import 'package:flutter/material.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardRow extends StatefulWidget {
  const KeyboardRow({super.key});

  @override
  State<KeyboardRow> createState() => _KeyboardRowState();
}

class _KeyboardRowState extends State<KeyboardRow> {
  List<bool> _selections = List.generate(3, (index) => false);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ToggleButtons(
          isSelected: _selections,
          onPressed: (index) {
            setState(() {
              _selections[index] = !_selections[index];
            });
            context.read<TextEditorBloc>().add(
                  TextEditorKeyboardRowChange(
                    isBold: _selections[0],
                    isItalic: _selections[1],
                    isUnderlined: _selections[2],
                  ),
                );
          },
          children: const [
            Icon(Icons.format_bold),
            Icon(Icons.format_italic),
            Icon(Icons.format_underline)
          ],
        )
      ],
    );
  }
}
