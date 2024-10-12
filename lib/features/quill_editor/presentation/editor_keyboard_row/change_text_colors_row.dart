import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/cubit/editor_keyboard_row_cubit.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/editor_keyboard_row.dart';

class ChangeTextColorsRow extends StatelessWidget {
  ChangeTextColorsRow({super.key, required this.controller});
  QuillController controller;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: QuillToolbar(
          child: Row(
        children: [
          IconButton(
              onPressed: () {
                context.read<EditorKeyboardRowCubit>().selectFormatChars();
              },
              icon: Icon(Icons.arrow_back)),
          _ColorButton(color: Colors.red),
          _ColorButton(color: Colors.blue),
          _ColorButton(color: Colors.green),
          _ColorButton(color: Colors.yellow),
          _ColorButton(color: Colors.purple),
        ],
      )),
    );
  }
}

class _ColorButton extends StatelessWidget {
  _ColorButton({super.key, required this.color});
  Color color;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          context.read<EditorKeyboardRowCubit>().changeTextColor(color);
        },
        child: Container(
          height: 24,
          width: 24,
          color: color,
        ));
  }
}
