import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/new_rows/keyboard_text_row.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/new_rows/color_rows/color_selectors.dart';

class KeyboardTextColorRow extends StatefulWidget {
  const KeyboardTextColorRow({super.key});

  @override
  State<KeyboardTextColorRow> createState() => _KeyboardTextColorRowState();
}

class _KeyboardTextColorRowState extends State<KeyboardTextColorRow> {
  @override
  Widget build(BuildContext context) {
    final textEditorBloc = context.read<TextEditorBloc>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        KeyboardRowContainer(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const _DefaultTextColorSelector(),
              ColorSelector(
                color: UIColors.red,
                onPressed: () => context
                    .read<KeyboardRowCubit>()
                    .changeTextColor(UIColors.red, textEditorBloc),
              ),
              ColorSelector(
                color: UIColors.yellow,
                onPressed: () => context
                    .read<KeyboardRowCubit>()
                    .changeTextColor(UIColors.yellow, textEditorBloc),
              ),
              ColorSelector(
                color: UIColors.green,
                onPressed: () => context
                    .read<KeyboardRowCubit>()
                    .changeTextColor(UIColors.green, textEditorBloc),
              ),
              ColorSelector(
                color: UIColors.blue,
                onPressed: () => context
                    .read<KeyboardRowCubit>()
                    .changeTextColor(UIColors.blue, textEditorBloc),
              ),
              ColorSelector(
                color: UIColors.purple,
                onPressed: () => context
                    .read<KeyboardRowCubit>()
                    .changeTextColor(UIColors.purple, textEditorBloc),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        const KeyboardTextRow(),
      ],
    );
  }
}


class _DefaultTextColorSelector extends StatelessWidget {
  const _DefaultTextColorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context
                    .read<KeyboardRowCubit>()
                    .changeTextColor(UIColors.textLight, context.read<TextEditorBloc>());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Container(
              height: 28,
              width: 12,
              decoration: const BoxDecoration(
                  color: UIColors.textLight,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(UIConstants.cornerRadius),
                      bottomLeft: Radius.circular(UIConstants.cornerRadius))),
            ),
            Container(
              height: 28,
              width: 12,
              decoration: const BoxDecoration(
                  color: UIColors.textDark,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(UIConstants.cornerRadius),
                      bottomRight: Radius.circular(UIConstants.cornerRadius))),
            ),
          ],
        ),
      ),
    );
  }
}
