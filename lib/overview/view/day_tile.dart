import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class DayTile extends StatelessWidget {
  const DayTile({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    final days = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final clastests = List.generate(7, (index) => false);
    final streak = List.generate(7, (index) => true);

    final now = DateTime.now();
    final day = now.subtract(Duration(days: now.weekday - 1 - index)).day;
    final isToday = day == now.day;
    final isClastest = clastests[index];
    final isStreak = streak[index];
    final width = (MediaQuery.of(context).size.width -
            2 * UIConstants.cardHorizontalPadding -
            2 * UIConstants.pageHorizontalPadding) /
        7;

    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            days[index],
            style: UIText.normal.copyWith(color: UIColors.overlay),
          ),
          const SizedBox(
            height: UIConstants.defaultSize,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: width / 1.2,
                width: width / 1.2,
                decoration: BoxDecoration(
                  color: isToday ? UIColors.textDark : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
              ),
              Text(
                '$day',
                style: UIText.label.copyWith(
                    color: isToday ? UIColors.primary : UIColors.textDark,),
              ),
              if (isToday)
                Positioned(
                  bottom: 5,
                  child: Container(
                    height: 5,
                    width: 5,
                    decoration: const BoxDecoration(
                      color: UIColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
