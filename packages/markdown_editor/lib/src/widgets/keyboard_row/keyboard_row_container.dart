import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class KeyboardRowContainer extends StatelessWidget {
  KeyboardRowContainer({super.key, required this.child, this.onBottomSheet=false});
  Widget child;
  bool onBottomSheet;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
          color: onBottomSheet?UIColors.onOverlayCard: UIColors.overlay,
          borderRadius:
              BorderRadius.all(Radius.circular(UIConstants.cornerRadius))),
      child: child,
    );
  }
}
