import 'package:flutter/material.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/new_rows/keyboard_text_row.dart';
import 'package:ui_components/ui_components.dart';

class KeyboardTextColorRow extends StatefulWidget {
  const KeyboardTextColorRow({super.key});

  @override
  State<KeyboardTextColorRow> createState() => _KeyboardTextColorRowState();
}

class _KeyboardTextColorRowState extends State<KeyboardTextColorRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        KeyboardRowContainer(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ColorSelector(color: UIColors.textLight),
              _ColorSelector(color: UIColors.red),
              _ColorSelector(color: UIColors.yellow),
              _ColorSelector(color: UIColors.green),
              _ColorSelector(color: UIColors.blue),
              _ColorSelector(color: UIColors.purple),

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

class _ColorSelector extends StatelessWidget {
  _ColorSelector({required this.color});
  Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(UIConstants.cornerRadius),),),
      ),
    );
  }
}
