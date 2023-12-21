import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class KeyboardRowContainer extends StatelessWidget {
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
              const BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),),
      child: child,
    );
  }
}
