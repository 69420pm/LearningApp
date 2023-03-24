import "package:flutter/material.dart";

class KeyboardExpandable extends StatelessWidget {
  KeyboardExpandable({super.key, required this.icon, this.onPressed});
  Function? onPressed;
  Icon icon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!.call();
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.shadow,
      ),
      child: icon,
    );
  }
}
