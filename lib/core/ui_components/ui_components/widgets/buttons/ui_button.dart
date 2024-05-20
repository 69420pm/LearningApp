import 'package:flutter/material.dart';

class UIButton extends StatelessWidget {
  const UIButton({super.key, required this.child, required this.onPressed});

  /// displayed child
  final Widget child;

  /// callback when button gets pressed
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: SizedBox(
        height: 44,
        width: 44,
        child: Center(child: child),
      ),
    );
  }
}
