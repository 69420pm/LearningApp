import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';

class UICardButton extends StatelessWidget {
  const UICardButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color = UIColors.background,
    this.hollow = false,
  });

  final Function() onPressed;
  final Text text;
  final Color color;
  final bool hollow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: hollow ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
          border: Border.all(
            color: hollow ? color : Colors.transparent,
            width: UIConstants.borderWidth,
          ),
        ),
        alignment: Alignment.center,
        child: text,
      ),
    );
  }
}
