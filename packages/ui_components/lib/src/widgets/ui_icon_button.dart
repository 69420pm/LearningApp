import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIIconButton extends StatelessWidget {
  const UIIconButton({super.key, required this.icon, required this.onPressed});

  /// displayed icon
  final Icon icon;

  /// callback when button gets pressed
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: icon,
        iconSize: UIConstants.iconSize,
        onPressed: onPressed,
        style: ButtonStyle());
  }
}
