// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIBottomSheet extends StatelessWidget {
  const UIBottomSheet({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(UIConstants.cornerRadius),
            topRight: Radius.circular(UIConstants.cornerRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: UIConstants.defaultSize,
              ),
              child: Container(
                height: 4,
                width: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(.4),
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.defaultSize * 2,
                  vertical: UIConstants.defaultSize,),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
