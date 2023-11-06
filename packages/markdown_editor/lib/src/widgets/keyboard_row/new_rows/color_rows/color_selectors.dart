import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';


class ColorSelector extends StatelessWidget {
  ColorSelector({super.key, required this.color, required this.onPressed});
  Color color;
  void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
          ),
        ),
      ),
    );
  }
}
