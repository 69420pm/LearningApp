import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/cubit/keyboard_row_cubit.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_both_rows_add_tile.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_lower_row_text_tile.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_upper_row_extra_format.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_upper_row_text_colors.dart';

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
              const KeyboardUpperRowTextColors(),
              KeyboardLowerRowTextTile(),
            ],
          );
        } else if (state is KeyboardRowFavorites) {
          return Column(
            children: [
              KeyboardLowerRowTextTile(),
            ],
          );
        } else if (state is KeyboardRowExtraFormat) {
          return Column(
            children: [
              KeyboardUpperRowExtraFormat(),
              KeyboardLowerRowTextTile()
            ],
          );
        } else if (state is KeyboardRowNewTextTile) {
          return Column(
            children: [const KeyboardBothRowsAddTile()],
          );
        }
        return Column(
          children: [
            const KeyboardUpperRowTextColors(),
            KeyboardLowerRowTextTile(),
          ],
        );
      },
    );
  }

  static Color returnColorFromTextColor(TextColor textColor) {
    switch (textColor) {
      case TextColor.white:
        return Colors.white;
      case TextColor.white60:
        return Colors.white60;
      case TextColor.white38:
        return Colors.white38;
      case TextColor.brown:
        return Colors.brown;
      case TextColor.orange:
        return Colors.orange;
      case TextColor.yellow:
        return Colors.yellow;
      case TextColor.green:
        return Colors.green;
      case TextColor.blue:
        return Colors.blue;
      case TextColor.purple:
        return Colors.purple;
      case TextColor.pink:
        return Colors.pink;
      case TextColor.red:
        return Colors.red;
    }
  }

  static Color returnColorFromBackgroundColor(TextBackgroundColor color) {
    switch (color) {
      case TextBackgroundColor.noBG:
        return Colors.transparent;
      case TextBackgroundColor.white60BG:
        return Colors.white60;
      case TextBackgroundColor.white38BG:
        return Colors.white38;
      case TextBackgroundColor.brownBG:
        return Colors.brown;
      case TextBackgroundColor.orangeBG:
        return Colors.orange;
      case TextBackgroundColor.yellowBG:
        return Colors.yellow;
      case TextBackgroundColor.greenBG:
        return Colors.green;
      case TextBackgroundColor.blueBG:
        return Colors.blue;
      case TextBackgroundColor.purpleBG:
      return Colors.purple;
      case TextBackgroundColor.pinkBG:
        return Colors.pink;
      case TextBackgroundColor.redBG:
        return Colors.red;
    }
  }
}
