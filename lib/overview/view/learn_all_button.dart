import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class LearnAllButton extends StatelessWidget {
  const LearnAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return UICard(
      color: UIColors.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Learn All',
                style: UIText.titleBig.copyWith(color: UIColors.textDark),
              ),
              const SizedBox(
                height: UIConstants.cardItemPadding / 4,
              ),
              Text(
                '69 Cards remaining',
                style: UIText.label.copyWith(
                  color: UIColors.textDark,
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
