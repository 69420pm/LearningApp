import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
class UIIconButtonLarge extends StatefulWidget {
  const UIIconButtonLarge({
    super.key,
    required this.icon,
    required this.onPressed,
    this.onBottomSheet = true,
  });

  /// displayed icon
  final Widget icon;

  /// callback when button gets pressed
  final void Function() onPressed;

  /// whether button is on bottom sheet do set background color
  final bool onBottomSheet;

  @override
  State<UIIconButtonLarge> createState() => _UIIconButtonLargeState();
}

class _UIIconButtonLargeState extends State<UIIconButtonLarge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: widget.onBottomSheet?UIColors.onOverlayCard:UIColors.overlay,
        borderRadius: const BorderRadius.all(Radius.circular(420)),
      ),
      child: IconButton(
        icon: widget.icon,
        iconSize: UIConstants.iconSize,
        onPressed: widget.onPressed,
        style: const ButtonStyle(),
      ),
    );
  }
}
