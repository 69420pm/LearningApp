import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIButton extends StatelessWidget {
  const UIButton({super.key, required this.child, required this.onPressed});

  /// displayed child
  final Widget child;

  /// callback when button gets pressed
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onPressed, child: Padding(
      padding: const EdgeInsets.all(UIConstants.itemPadding/2),
      child: child,
    ));
  }
}
