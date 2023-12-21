// import 'package:flutter/material.dart';

// class KeyboardToggle extends StatefulWidget {
//   KeyboardToggle(
//       {super.key,
//       required this.icon,
//       this.onPressed,
//       this.width = 50,
//       this.height = 40,});
//   Icon icon;
//   Function? onPressed;
//   double width;
//   double height;
//   @override
//   State<KeyboardToggle> createState() => _KeyboardToggleState();
// }

// class _KeyboardToggleState extends State<KeyboardToggle> {
//   bool _isPressed = false;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: widget.width,
//       height: widget.height,
//       child: IconButton(
//         icon: widget.icon,
//         color: _isPressed
//             ? Theme.of(context).colorScheme.primary
//             : Theme.of(context).colorScheme.onSurfaceVariant,
//         onPressed: () {
//           setState(() {
//             _isPressed = !_isPressed;
//           });
//           if (widget.onPressed != null) {
//             widget.onPressed!.call();
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';import 'package:flutter_animate/flutter_animate.dart';

class KeyboardToggle extends StatefulWidget {
  KeyboardToggle(
      {super.key,
      required this.icon,
      required this.onPressed,
      this.toggled = false,});

  /// displayed icon
  final UIIcon icon;

  /// callback when button gets pressed
  final void Function(bool value) onPressed;

  bool toggled;
  @override
  State<KeyboardToggle> createState() => _KeyboardToggleState();
}

class _KeyboardToggleState extends State<KeyboardToggle> {
  @override
  Widget build(BuildContext context) {
    final startColor = widget.icon.color ?? Colors.white;
    const animateColor = UIColors.smallText;
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.toggled = !widget.toggled;
        });
        widget.onPressed.call(widget.toggled);
      },
      behavior: HitTestBehavior.opaque,
      // ! this container doesn't get displayed, probably bug of flutter_animate
      child: const SizedBox(
        height: 48,
        width: 48,
      )
          .animate(
            target: widget.toggled ? 1 : 0,
          )
          .custom(
            duration: 25.ms,
            builder: (context, value, child) {
              return SizedBox(
                height: 48,
                width: 48,
                child: widget.icon.copyWith(
                  color: Color.lerp(animateColor, startColor, value),
                ),
              );
            },
          ),
    );
  }
}
