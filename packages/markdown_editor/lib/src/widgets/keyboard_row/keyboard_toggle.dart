import 'package:flutter/material.dart';

class KeyboardToggle extends StatefulWidget {
  KeyboardToggle(
      {super.key,
      required this.icon,
      this.onPressed,
      this.width = 50,
      this.height = 40,});
  Icon icon;
  Function? onPressed;
  double width;
  double height;
  @override
  State<KeyboardToggle> createState() => _KeyboardToggleState();
}

class _KeyboardToggleState extends State<KeyboardToggle> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: IconButton(
        icon: widget.icon,
        color: _isPressed
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
        onPressed: () {
          setState(() {
            _isPressed = !_isPressed;
          });
          if (widget.onPressed != null) {
            widget.onPressed!.call();
          }
        },
      ),
    );
  }
}
