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
        colorSelectorIconButton(
          icon: Icons.format_color_text,
          color: context.read<TextEditorBloc>().isDefaultOnBackgroundTextColor
              ? Theme.of(context).colorScheme.onSurfaceVariant
              : context.read<TextEditorBloc>().textColor,
          onColorChanged: (color, isDefault) {
            context.read<TextEditorBloc>().add(
                  TextEditorKeyboardRowChange(
                    textColor: color,
                    isDefaultOnBackgroundTextColor: isDefault,
                  ),
                );
            Navigator.pop(context);
          },
        ),
        colorSelectorIconButton(
          icon: Icons.format_color_fill,
          color: context.read<TextEditorBloc>().textBackgroundColor ==
                  Colors.transparent
              ? Theme.of(context).colorScheme.onSurfaceVariant
              : context.read<TextEditorBloc>().textBackgroundColor,
          onColorChanged: (color, isDefault) {
            context.read<TextEditorBloc>().add(
                  TextEditorKeyboardRowChange(
                    textBackgroundColor:
                        isDefault ?? false ? Colors.transparent : color,
                  ),
                );
            Navigator.pop(context);
          },
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

class colorSelectorIconButton extends StatefulWidget {
  colorSelectorIconButton({
    super.key,
    required this.onColorChanged,
    required this.color,
    required this.icon,
  });
  final void Function(Color?, bool?) onColorChanged;
  Color color;
  final IconData icon;
  @override
  State<colorSelectorIconButton> createState() =>
      _colorSelectorIconButtonState();
}

class _colorSelectorIconButtonState extends State<colorSelectorIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.icon,
        color: widget.color,
      ),
      onPressed: () => showModalBottomSheet(
        context: context,
        builder: (_) => BlocProvider.value(
          value: context.read<TextEditorBloc>(),
          child: UIColorPicker(
            showRemoveButton: true,
            onColorChanged: (color, isDefault) => setState(() {
              widget.color =
                  color ?? Theme.of(context).colorScheme.onSurfaceVariant;
              widget.onColorChanged(color, isDefault);
            }),
          ),
        ),
      ),
    );
  }
}
