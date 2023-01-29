import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIBottomSheet extends StatelessWidget {
  const UIBottomSheet({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(UISizeConstants.cornerRadius),
                topRight: Radius.circular(UISizeConstants.cornerRadius),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: UISizeConstants.defaultSize,),
                  child: Container(
                    height: 4,
                    width: 32,
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withOpacity(.4),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),),
                  ),
                ),
                child,
              ],
            ),
          )
        ],
      ),
    );
  }
}
