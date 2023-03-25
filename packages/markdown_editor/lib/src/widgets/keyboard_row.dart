import 'package:flutter/material.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/cubit/keyboard_row_cubit.dart';
import 'package:markdown_editor/src/widgets/keyboard_expandable.dart';
import 'package:markdown_editor/src/widgets/keyboard_selectable.dart';
import 'package:markdown_editor/src/widgets/keyboard_toggle.dart';

class KeyboardRow extends StatelessWidget {
  KeyboardRow({super.key});

  List<bool> _selections = List.generate(7, (index) => false);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeyboardRowCubit, KeyboardRowState>(
      builder: (context, state) {
        if (state is KeyboardRowTextColors) {
          return Column(
            children: [
              const _KeyboardUpperRowTextColors(),
              _KeyboardLowerRowTextTile(),
            ],
          );
        } else if (state is KeyboardRowFavorites) {
          return Column(
            children: [
              _KeyboardLowerRowTextTile(),
            ],
          );
        }
        return Column(
          children: [
            const _KeyboardUpperRowTextColors(),
            _KeyboardLowerRowTextTile(),
          ],
        );
      },
    );
  }
}

class _KeyboardLowerRowTextTile extends StatelessWidget {
  _KeyboardLowerRowTextTile({super.key});
  bool isBold = false;
  bool isItalic = false;
  bool isUnderlined = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        KeyboardToggle(
          icon: const Icon(Icons.format_bold),
          onPressed: () {
            isBold = !isBold;
            context.read<TextEditorBloc>().add(
                  TextEditorKeyboardRowChange(
                    isBold: isBold,
                    isItalic: isItalic,
                    isUnderlined: isUnderlined,
                  ),
                );
          },
        ),
        KeyboardToggle(
          icon: const Icon(Icons.format_italic),
          onPressed: () {
            isItalic = !isItalic;
            context.read<TextEditorBloc>().add(
                  TextEditorKeyboardRowChange(
                    isBold: isBold,
                    isItalic: isItalic,
                    isUnderlined: isUnderlined,
                  ),
                );
          },
        ),
        KeyboardToggle(
          icon: const Icon(Icons.format_underline),
          onPressed: () {
            isUnderlined = !isUnderlined;
            context.read<TextEditorBloc>().add(
                  TextEditorKeyboardRowChange(
                    isBold: isBold,
                    isItalic: isItalic,
                    isUnderlined: isUnderlined,
                  ),
                );
          },
        ),
        KeyboardExpandable(
          icon: const Icon(Icons.format_color_text),
          onPressed: () => context.read<KeyboardRowCubit>().expandTextColors(),
        ),
        KeyboardExpandable(icon: const Icon(Icons.functions)),
        Container(
          width: 2,
          color: Theme.of(context).colorScheme.outline,
          height: 38,
        ),
        KeyboardExpandable(
          icon: const Icon(Icons.add),
          width: 70,
        ),
      ],
    );
  }
}

class _KeyboardUpperRowTextColors extends StatelessWidget {
  const _KeyboardUpperRowTextColors({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 20,
        // width: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            _KeyboardColorSelectable(color: Colors.white),
            _KeyboardColorSelectable(color: Colors.white60),
            _KeyboardColorSelectable(color: Colors.white38),
            _KeyboardColorSelectable(color: Colors.brown),
            _KeyboardColorSelectable(color: Colors.orange),
            _KeyboardColorSelectable(color: Colors.yellow),
            _KeyboardColorSelectable(color: Colors.green),
            _KeyboardColorSelectable(color: Colors.blue),
            _KeyboardColorSelectable(color: Colors.purple),
            _KeyboardColorSelectable(color: Colors.pink),
            _KeyboardColorSelectable(color: Colors.red),
          ],
        ),
      ),
    );
  }
}

class _KeyboardColorSelectable extends StatelessWidget {
  _KeyboardColorSelectable({super.key, required this.color});
  Color color;
  @override
  Widget build(BuildContext context) {
    return KeyboardSelectable(
      icon: Icon(
        Icons.format_color_text,
        color: color,
      ),
      width: 40,
    );
  }
}
