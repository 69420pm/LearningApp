import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class LearnAllButton extends StatelessWidget {
  const LearnAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return UICard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Learn All',
                style: UIText.titleBig,
              ),
              const SizedBox(height: UIConstants.cardItemPadding/4,),
              Text(
                '69 Cards remaining',
                style: UIText.label.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              )
            ],
          ),
          UIIcons.arrowForward
        ],
      ),
    );
  }
}
