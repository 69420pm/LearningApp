import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class DayTile extends StatelessWidget {
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

    return SizedBox(
      width: (MediaQuery.of(context).size.width -
              4 * UIConstants.cardHorizontalPadding) /
          7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            days[index],
            style: UIText.normal.copyWith(color: UIColors.overlay),
          ),
          SizedBox(
            height: UIConstants.defaultSize,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: isToday ? UIColors.textDark : Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ),
              Text(
                '$day',
                style: UIText.label.copyWith(
                    color: isToday ? UIColors.primary : UIColors.textDark),
              ),
              if (isToday)
                Positioned(
                  bottom: 6,
                  child: Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                      color: UIColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
