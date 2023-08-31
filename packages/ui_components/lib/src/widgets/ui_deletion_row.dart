import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIDeletionRow extends StatelessWidget {
  UIDeletionRow(
      {super.key,
      required this.deletionText,
      required this.onPressed,
      this.horizontalPadding = false});

  /// whether the entire row should have horizontalPadding,
  /// when true padding is [UIConstants.cardHorizontalPadding]
  final bool horizontalPadding;

  /// lable text
  final String deletionText;

  void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal:
                horizontalPadding ? UIConstants.cardHorizontalPadding : 0),
        child: UIIconButton(
          icon: UIIcons.delete,
          onPressed: onPressed,
          text: deletionText,
          swapTextWithIcon: true,
        ));
  }
}
