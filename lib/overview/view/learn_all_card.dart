import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class LearnAllCard extends StatelessWidget {
  const LearnAllCard({super.key});

  @override
  Widget build(BuildContext context) {
    return UICard(
      useGradient: true,
      distanceToTop: 80,
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
                height: UIConstants.defaultSize,
              ),
              Text(
                '69 Cards remaining',
                style: UIText.label.copyWith(
                  color: UIColors.textDark,
                ),
              ),
            ],
          ),
          UIIcons.arrowForwardNormal.copyWith(color: UIColors.overlay),
        ],
      ),
    );
  }
}
