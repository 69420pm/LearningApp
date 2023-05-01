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
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(UIConstants.cornerRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.defaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIGradientText(text: 'Learn all '),
              // SizedBox(height: UiSizeConstants.defaultSize),
              Text(
                '40 remaining',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
