import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/overview/view/progress_bar.dart';
import 'package:ui_components/ui_components.dart';

class LearnAllButton extends StatelessWidget {
  const LearnAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return UICard(
        hight: UIConstants.defaultSize * 13,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: UIConstants.defaultSize * 4,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learn All',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 50,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                Text(
                  "69 Cards remaining",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                )
              ],
            ),
          ],
        ));
  }
}
