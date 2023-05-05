import 'package:flutter/material.dart';
import 'package:learning_app/overview/view/progress_bar.dart';
import 'package:ui_components/ui_components.dart';

class LearnAllButton extends StatelessWidget {
  const LearnAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //TODO on tap function lol
      onTap: () {
        Navigator.pushNamed(context, '/learn');
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(UIConstants.cornerRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 2 * UIConstants.defaultSize,
              right: 2 * UIConstants.defaultSize,
              bottom: 2 * UIConstants.defaultSize,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Learn All',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 50,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,),
              ),
              ProgressBar(
                  width: MediaQuery.of(context).size.width -
                      4 * UIConstants.defaultSize -
                      2 * UIConstants.paddingEdge,
                  progress: 0.8,)
            ],
          ),
        ),
      ),
    );
  }
}
