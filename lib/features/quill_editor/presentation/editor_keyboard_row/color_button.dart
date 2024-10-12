import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learning_app/features/quill_editor/helper/quill_helper.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/cubit/editor_keyboard_row_cubit.dart';

class ColorButton extends StatefulWidget {
  ColorButton({super.key, required this.controller});
  QuillController controller;
  @override
  State<ColorButton> createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton> {
  Color color = Colors.white;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(_didChangeEditUpdate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.controller.removeListener(_didChangeEditUpdate);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.getSelectionStyle().attributes['color'] == null) {
      color = Colors.white;
    } else {
      color = stringToColor(
          widget.controller.getSelectionStyle().attributes['color']!.value);
    }
    return IconButton(
      onPressed: () {
        context.read<EditorKeyboardRowCubit>().selectChangeTextColors();
      },
      icon: Icon(Icons.color_lens),
      color: color,
    );
  }

  void _didChangeEditUpdate() {
    setState(() {
      color;
    });
  }
}
