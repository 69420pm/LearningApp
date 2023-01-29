import 'package:flutter/material.dart';
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
        height: UISizeConstants.defaultSize * 10,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(
                Radius.circular(UISizeConstants.cornerRadius),),),
        child: Padding(
          padding: const EdgeInsets.all(UISizeConstants.defaultSize),
          child: Row(
            children: [
              const Icon(Icons.question_mark),
              const SizedBox(width: UISizeConstants.defaultSize),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learn all ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,),
                  ),
                  // SizedBox(height: UiSizeConstants.defaultSize),
                  Text(
                    '40 Cards remaining',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
              const SizedBox(width: UISizeConstants.defaultSize * 3),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(UISizeConstants.cornerRadius),),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
