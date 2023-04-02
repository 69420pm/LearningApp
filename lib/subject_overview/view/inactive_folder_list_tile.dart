import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ui_components/ui_components.dart';

class PlaceholderWhileDragging extends StatelessWidget {
  const PlaceholderWhileDragging({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: UISizeConstants.defaultSize * 5,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(UISizeConstants.cornerRadius)),
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      ),
    );
  }
}
