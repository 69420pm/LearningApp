import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';

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
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: UIConstants.cardHorizontalPadding,
              vertical: UIConstants.cardVerticalPadding,
            ),
        child: child,
      ),
    );
  }
}
