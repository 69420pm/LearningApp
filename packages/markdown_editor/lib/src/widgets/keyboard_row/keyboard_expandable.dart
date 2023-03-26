import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/cubit/keyboard_row_cubit.dart';

class KeyboardExpandable extends StatelessWidget {
  KeyboardExpandable({
    super.key,
    required this.icon,
    this.onPressed,
    this.width = 50,
  });
  Function? onPressed;
  Icon icon;
  double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!.call();
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          foregroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.shadow,
        ),
        child: icon,
      ),
    );
  }
}
