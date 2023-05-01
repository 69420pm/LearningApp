import 'package:flutter/material.dart';
import 'package:ui_components/src/ui_size_constants.dart';

class UIButton extends StatelessWidget {
  const UIButton({
    super.key,
    this.color,
    this.textColor,
    this.onTap,
    this.height,
    this.width,
    this.lable,
    this.child,
  });

  final Color? color, textColor;
  final void Function()? onTap;
  final double? height, width;
  final String? lable;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height ?? UISizeConstants.defaultSize * 4,
          width: width,
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(
              Radius.circular(UISizeConstants.cornerRadius),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UISizeConstants.defaultSize * 2,
                vertical: UISizeConstants.defaultSize,
              ),
              child: child ??
                  Text(
                    lable ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor ??
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
