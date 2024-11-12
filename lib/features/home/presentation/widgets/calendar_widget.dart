import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';

class WeekRow extends StatelessWidget {
  const WeekRow({super.key});

  @override
  Widget build(BuildContext context) {
    //get from settings
    const isSundayFirstDayOfWeek = false;

    //get from database
    final streaks = [true, true, false, true, false, false, false];

    final now = DateTime.now();
    final firstDayOfCurrentWeek = now.subtract(
        Duration(days: now.weekday - (isSundayFirstDayOfWeek ? 0 : 1)));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.2),
        borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
      ),
      height: UIConstants.defaultSize * 12,
      width: 500,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultSize * 2,
          vertical: UIConstants.defaultSize,
        ),
        child: Row(
          children: [
            ...List.generate(
              7,
              (index) {
                final day = firstDayOfCurrentWeek.add(Duration(days: index));
                final streakLeft = index == 0 ? false : streaks[index - 1];
                final streakRight = index == 6 ? false : streaks[index + 1];
                final hasStreak = streaks[index];

                //Expanded doesn't work with ListView.builder, so List.generate is used
                return Expanded(
                  child: _DayTile(
                    day: day,
                    streakLeft: streakLeft,
                    hasStreak: hasStreak,
                    streakRight: streakRight,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({
    super.key,
    required this.day,
    required this.streakLeft,
    required this.hasStreak,
    required this.streakRight,
  });

  final DateTime day;
  final bool streakLeft;
  final bool hasStreak;
  final bool streakRight;

  @override
  Widget build(BuildContext context) {
    const border = BorderSide(
      color: UIColors.background,
      width: UIConstants.borderWidth,
    );

    final isToday = day.day == DateTime.now().day;

    return Column(
      children: [
        SizedBox(
          height: UIConstants.defaultSize * 3,
          child: Center(
            child: Text(
              DateFormat.EEEE(Intl.getCurrentLocale())
                  .dateSymbols
                  .STANDALONESHORTWEEKDAYS
                  .elementAt(day.weekday > 6 ? 0 : day.weekday),
              style: UIText.normal.copyWith(
                color: UIColors.textDark,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(
                    streakLeft && hasStreak ? 0 : UIConstants.cornerRadius),
                right: Radius.circular(
                    streakRight && hasStreak ? 0 : UIConstants.cornerRadius),
              ),
              border: Border(
                top: hasStreak ? border : BorderSide.none,
                bottom: hasStreak ? border : BorderSide.none,
                left: hasStreak && !streakLeft ? border : BorderSide.none,
                right: hasStreak && !streakRight ? border : BorderSide.none,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(UIConstants.borderWidth),
              child: Container(
                decoration: BoxDecoration(
                  color: isToday ? UIColors.background : Colors.transparent,
                  borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
                ),
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: UIText.normalBold.copyWith(
                      color: isToday ? UIColors.primary : UIColors.textDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
