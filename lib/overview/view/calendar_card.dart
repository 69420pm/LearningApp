import 'package:flutter/material.dart';
import 'package:learning_app/overview/view/day_tile.dart';
import 'package:ui_components/ui_components.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return UICard(
      useGradient: true,
      distanceToTop: 280,
      color: UIColors.primary,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calendar',
                    style: UIText.titleBig.copyWith(color: UIColors.textDark),
                  ),
                  const SizedBox(
                    height: UIConstants.defaultSize,
                  ),
                  Text(
                    '69th July 2023',
                    style: UIText.label.copyWith(
                      color: UIColors.textDark,
                    ),
                  )
                ],
              ),
              UIIcons.arrowForward.copyWith(color: UIColors.overlay)
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPadding,
          ),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 7,
                itemBuilder: (context, index) => DayTile(index: index)),
          )
        ],
      ),
    );
  }
}
