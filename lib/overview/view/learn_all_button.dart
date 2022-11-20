import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ui_components/ui_components.dart';

class LearnAllButton extends StatelessWidget {
  const LearnAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //TODO on tap function
      onTap: () {
        Navigator.pushNamed(context, "/learn");
      },
      child: Container(
        height: UISizeConstants.defaultSize * 10,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.all(
                Radius.circular(UISizeConstants.cornerRadius))),
        child: Padding(
          padding: EdgeInsets.all(UISizeConstants.defaultSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.question_mark),
              SizedBox(width: UISizeConstants.defaultSize),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Learn all ",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(height: UiSizeConstants.defaultSize),
                  Text(
                    "40 Cards remaining",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
              SizedBox(width: UISizeConstants.defaultSize * 3),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.all(
                          Radius.circular(UISizeConstants.cornerRadius))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
