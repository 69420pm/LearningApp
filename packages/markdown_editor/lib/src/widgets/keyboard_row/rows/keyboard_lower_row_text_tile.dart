// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_toggle.dart';
import 'package:ui_components/ui_components.dart';

// ignore: must_be_immutable
class KeyboardLowerRowTextTile extends StatelessWidget {
  KeyboardLowerRowTextTile({super.key});
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
        IconButton(
          icon: Icon(
            Icons.format_color_text,
            color:
                context.read<TextEditorBloc>().textColor == Colors.transparent
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : context.read<TextEditorBloc>().textColor,
          ),
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<TextEditorBloc>(),
              child: UIColorPicker(
                onColorChanged: (color, isDefault) =>
                    context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textColor: color,
                            isDefaultOnBackgroundTextColor: isDefault,
                          ),
                        ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.format_color_fill,
              color: context.read<TextEditorBloc>().textBackgroundColor),
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<TextEditorBloc>(),
              child: UIColorPicker(
                onColorChanged: (color, isDefault) =>
                    context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textBackgroundColor: color,
                          ),
                        ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.functions),
          onPressed: () => context.read<KeyboardRowCubit>().expandExtraFormat(),
        ),
        Container(
          width: 2,
          color: Theme.of(context).colorScheme.outline,
          height: 38,
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () =>
              context.read<KeyboardRowCubit>().expandAddNewTextTile(),
        ),
      ],
    );
  }
}
