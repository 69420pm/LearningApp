import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_button.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';

class KeyboardLatexButton extends StatelessWidget {
  KeyboardLatexButton({
    super.key,
    this.icon,
    this.text,
    required this.onPressed,
    this.onDoubleTap,
  });
  UIIcon? icon;
  String? text;
  void Function() onPressed;
  void Function()? onDoubleTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: const BoxDecoration(
        color: UIColors.onOverlayCard,
      ),
      child: Center(
        child: Builder(
          builder: (context) {
            if (icon != null) {
              return UIIconButton(
                icon: icon!,
                onPressed: onPressed,
                onDoubleTap: onDoubleTap,
              );
            } else {
              return UIButton(onPressed: onPressed, child: Text(text!));
            }
          },
        ),
      ),
    );
  }
}
