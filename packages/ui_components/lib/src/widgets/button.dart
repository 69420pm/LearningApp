import 'package:flutter/material.dart';
import 'package:ui_components/src/ui_constants.dart';

class UIButton extends StatelessWidget {
  const UIButton({
    super.key,
    this.color,
    this.textColor,
    this.onTap,
    this.height,
    this.width,
    this.lable,
  });

  final Color? color, textColor;
  final void Function()? onTap;
  final double? height, width;
  final String? lable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? UIConstants.defaultSize * 4,
        width: width,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(UIConstants.cornerRadius),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.defaultSize * 2,
              vertical: UIConstants.defaultSize,
            ),
            child: Text(
              lable ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor ??
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
