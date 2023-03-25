import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardSelectable extends StatelessWidget {
  KeyboardSelectable({
    super.key,
    required this.icon,
    this.onPressed,
    this.width = 100,
  });
  Function? onPressed;
  Icon icon;
  double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: width,
      child: Center(
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
      ),
    );
  }
}
