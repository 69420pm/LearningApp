import 'package:flutter/material.dart';
import 'package:ui_components/src/ui_constants.dart';
import 'package:ui_components/ui_components.dart';

class UIContainer extends StatelessWidget {
  UIContainer({super.key, required this.child});

  /// child of container
  Widget child;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
        color: UIColors.overlay,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.cardVerticalPaddingLarge,
          vertical: UIConstants.cardVerticalPadding,
        ),
        child: child,
      ),
    );
  }
}
