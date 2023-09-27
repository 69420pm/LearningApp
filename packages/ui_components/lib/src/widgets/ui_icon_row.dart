import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIIconRow extends StatelessWidget {
  UIIconRow(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed,
      this.horizontalPadding = false});

  /// whether the entire row should have horizontalPadding,
  /// when true padding is [UIConstants.cardHorizontalPadding]
  final bool horizontalPadding;

  /// lable text
  final String text;

  /// icon to display
  final UIIcon icon;

  /// on pressed
  void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal:
                horizontalPadding ? UIConstants.cardHorizontalPadding : 0),
        child: UIIconButton(
          icon: icon.copyWith(size: 28, color: UIColors.primary),
          onPressed: onPressed,
          text: text,
          textColor: UIColors.textLight,
          swapTextWithIcon: true,
        ));
  }
}
