import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIIconButtonLarge extends StatefulWidget {
  const UIIconButtonLarge({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  /// displayed icon
  final Widget icon;

  /// callback when button gets pressed
  final void Function() onPressed;

  @override
  State<UIIconButtonLarge> createState() => _UIIconButtonLargeState();
}

class _UIIconButtonLargeState extends State<UIIconButtonLarge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: const BoxDecoration(
        color: UIColors.onOverlayCard,
        borderRadius: BorderRadius.all(Radius.circular(420)),
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
