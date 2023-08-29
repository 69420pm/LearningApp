import 'package:flutter/material.dart';
import 'package:ui_components/src/ui_constants.dart';
import 'package:ui_components/ui_components.dart';

class UIContainer extends StatelessWidget {
  UIContainer({super.key, required this.child, this.padding});

  /// child of container
  Widget child;

  /// custom padding
  EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
        color: UIColors.overlay,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: UIConstants.cardHorizontalPadding,
          vertical: UIConstants.cardVerticalPadding,
        ),
        child: child,
      ),
    );
  }
}
