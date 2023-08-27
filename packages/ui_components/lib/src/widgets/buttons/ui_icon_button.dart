import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ui_components/ui_components.dart';

class UIIconButton extends StatefulWidget {
  const UIIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.alignment = Alignment.center,
    this.animateToWhite = false,
  });

  /// displayed icon
  final UIIcon icon;

  /// callback when button gets pressed
  final void Function() onPressed;

  /// how icon should be aligned in container
  final Alignment alignment;

  /// whether the icon should lighten up or darken
  final bool animateToWhite;

  @override
  State<UIIconButton> createState() => _UIIconButtonState();
}

class _UIIconButtonState extends State<UIIconButton> {
  bool isIconColored = false;

  @override
  Widget build(BuildContext context) {
    final startColor =
        widget.icon.color != null ? widget.icon.color : Colors.white;
    final animateColor = Color.fromARGB(
      128,
      startColor!.red,
      startColor!.blue,
      startColor!.green,
    );
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (details) {
        setState(() {
          isIconColored = true;
        });
      },
      onTapCancel: () {
        setState(() {
          isIconColored = false;
        });
      },
      onTapUp: (details) {
        setState(() {
          isIconColored = false;
        });
      },
      // ! this container doesn't get displayed, probably bug of flutter_animate
      child: Container(
        height: 44,
        width: 44,
        alignment: widget.alignment,
      )
          .animate(
            target: isIconColored ? 1 : 0,
          )
          .custom(
            duration: 50.ms,
            builder: (context, value, child) {
              return Container(
                height: 44,
                width: 44,
                child: widget.icon.copyWith(
                color: Color.lerp(startColor, animateColor, value),
                          ),
              );
            },
          ),
          
    );
  }
}
