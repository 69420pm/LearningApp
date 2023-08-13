import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIIconButton extends StatefulWidget {
  const UIIconButton({super.key, required this.icon, required this.onPressed});

  /// displayed icon
  final Widget icon;

  /// callback when button gets pressed
  final void Function() onPressed;

  @override
  State<UIIconButton> createState() => _UIIconButtonState();
}

class _UIIconButtonState extends State<UIIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: widget.icon,
        iconSize: UIConstants.iconSize,
        onPressed: widget.onPressed,
        style: ButtonStyle());
  }
}
