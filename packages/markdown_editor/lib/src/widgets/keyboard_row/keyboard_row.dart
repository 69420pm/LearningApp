import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/cubit/keyboard_row_cubit.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_both_rows_add_tile.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_lower_row_text_tile.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_upper_row_extra_format.dart';

class KeyboardRow extends StatelessWidget {
  KeyboardRow({super.key});

  final List<bool> _selections = List.generate(7, (index) => false);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeyboardRowCubit, KeyboardRowState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              if (state is KeyboardRowExtraFormat)
                KeyboardUpperRowExtraFormat(),
              if (state is KeyboardRowNewTextTile)
                const KeyboardBothRowsAddTile(),
              if (state is! KeyboardRowNewTextTile) KeyboardLowerRowTextTile(),
            ],
          ),
        );
      },
    );
  }
}
