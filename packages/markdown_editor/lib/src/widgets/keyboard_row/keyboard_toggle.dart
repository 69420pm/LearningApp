import 'package:flutter/material.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:ui_components/ui_components.dart';

class KeyboardToggle extends StatefulWidget {
  KeyboardToggle({super.key, required this.icon, this.onPressed});
  Icon icon;
  Function? onPressed;

  @override
  State<KeyboardToggle> createState() => _KeyboardToggleState();
}

class _KeyboardToggleState extends State<KeyboardToggle> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isPressed = !_isPressed;
          });
          if (widget.onPressed != null) {
            widget.onPressed!.call();
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          foregroundColor: _isPressed
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground,
          backgroundColor: _isPressed
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.shadow,
        ),
        child: Center(child: widget.icon),
      ),
    );
  }
}
