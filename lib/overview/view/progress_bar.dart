import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ui_components/ui_components.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.width, required this.progress});

  final double width;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Background
        Container(
          height: UIConstants.defaultSize * 2,
          width: width,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .onTertiaryContainer
                .withOpacity(0.5),
            borderRadius: const BorderRadius.all(
              Radius.circular(UIConstants.cornerRadius),
            ),
          ),
        ),

        //Moving Bar
        Container(
          height: UIConstants.defaultSize * 2,
          width: width * progress,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .onTertiaryContainer
                .withOpacity(1),
            borderRadius: const BorderRadius.all(
              Radius.circular(UIConstants.cornerRadius),
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .shimmer(
                color: Theme.of(context).colorScheme.primary,
                size: 2,
                curve: Curves.easeInOut,
                delay: 2000.ms,
                duration: 2000.ms,),
      ],
    );
  }
}
