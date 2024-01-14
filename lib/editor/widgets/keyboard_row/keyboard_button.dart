import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';class KeyboardButton extends StatelessWidget {
  KeyboardButton({super.key, required this.icon, required this.onPressed, this.onDoubleTap, this.withBackgroundColor=true});
  UIIcon icon;
  void Function() onPressed;
  void Function()? onDoubleTap;
  bool withBackgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
            color: withBackgroundColor? UIColors.overlay:Colors.transparent,
            borderRadius:
                const BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),),
        child: UIIconButton(
          icon: icon,
          onPressed: onPressed,
          onDoubleTap: onDoubleTap,
        ),);
  }
}

