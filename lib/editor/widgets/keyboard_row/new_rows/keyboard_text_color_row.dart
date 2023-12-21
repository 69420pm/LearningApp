import 'package:flutter/material.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:learning_app/editor/widgets/keyboard_row/new_rows/keyboard_text_row.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';import 'package:flutter_bloc/flutter_bloc.dart';
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
        KeyboardTextRow(isBold: textEditorBloc.isBold,
          isItalic: textEditorBloc.isItalic,
          isUnderlined: textEditorBloc.isUnderlined,
          textColor: textEditorBloc.textColor,
          backgroundColor: textEditorBloc.textBackgroundColor,),
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
