import 'package:flutter/material.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_selectable.dart';

class KeyboardUpperRowTextColors extends StatelessWidget {
  const KeyboardUpperRowTextColors({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 20,
        // width: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            _KeyboardColorSelectable(
              color: Colors.white,
              onPressed: () => context.read<TextEditorBloc>().add(
                    TextEditorKeyboardRowChange(textColor: TextColor.white),
                  ),
            ),
            _KeyboardColorSelectable(
              color: Colors.white60,
              onPressed: () => context.read<TextEditorBloc>().add(
                    TextEditorKeyboardRowChange(textColor: TextColor.white60),
                  ),
            ),
            _KeyboardColorSelectable(
              color: Colors.white38,
              onPressed: () => context.read<TextEditorBloc>().add(
                    TextEditorKeyboardRowChange(textColor: TextColor.white38),
                  ),
            ),
            _KeyboardColorSelectable(
              color: Colors.brown,
              onPressed: () => context.read<TextEditorBloc>().add(
                    TextEditorKeyboardRowChange(textColor: TextColor.brown),
                  ),
            ),
            _KeyboardColorSelectable(
              color: Colors.orange,
              onPressed: () => context.read<TextEditorBloc>().add(
                    TextEditorKeyboardRowChange(textColor: TextColor.orange),
                  ),
            ),
            _KeyboardColorSelectable(
              color: Colors.yellow,
              onPressed: () => context.read<TextEditorBloc>().add(
                    TextEditorKeyboardRowChange(textColor: TextColor.yellow),
                  ),
            ),
            _KeyboardColorSelectable(
              color: Colors.green,
              onPressed: () => context.read<TextEditorBloc>().add(
                    TextEditorKeyboardRowChange(textColor: TextColor.green),
                  ),
            ),
            _KeyboardColorSelectable(
              color: Colors.blue,
              onPressed: () => context.read<TextEditorBloc>().add(
                    TextEditorKeyboardRowChange(textColor: TextColor.blue),
                  ),
            ),
            _KeyboardColorSelectable(
              color: Colors.purple,
              onPressed: () => context.read<TextEditorBloc>().add(
                    TextEditorKeyboardRowChange(textColor: TextColor.purple),
                  ),
            ),
            _KeyboardColorSelectable(
              color: Colors.pink,
              onPressed: () => context.read<TextEditorBloc>().add(
                    TextEditorKeyboardRowChange(textColor: TextColor.pink),
                  ),
            ),
            _KeyboardColorSelectable(
              color: Colors.red,
              onPressed: () => context.read<TextEditorBloc>().add(
                    TextEditorKeyboardRowChange(textColor: TextColor.red),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyboardColorSelectable extends StatelessWidget {
  _KeyboardColorSelectable({super.key, required this.color, this.onPressed});
  Color color;
  Function? onPressed;
  @override
  Widget build(BuildContext context) {
    return KeyboardSelectable(
      icon: Icon(
        Icons.format_color_text,
        color: color,
      ),
      width: 40,
      onPressed: onPressed,
    );
  }
}
