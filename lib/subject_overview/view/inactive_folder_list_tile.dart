import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class PlaceholderWhileDragging extends StatelessWidget {
  const PlaceholderWhileDragging({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.defaultSize),
      child: Container(
        width: double.infinity,
        height: UIConstants.defaultSize * 5,
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
    );
  }
}
