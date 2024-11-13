import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button_large.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/calendar/widgets/day_tile.dart';
import 'package:learning_app/generated/l10n.dart';

class MonthTile extends StatefulWidget {
  const MonthTile({super.key});

  @override
  State<MonthTile> createState() => _MonthTileState();
}

class _MonthTileState extends State<MonthTile> {
  //get from settings
  final isSundayFirstDayOfWeek = false;

  //get from database

  final now =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  int monthOffset = 0;
  Widget build(BuildContext context) {
    final streaks =
        List.generate(20, (index) => now.subtract(Duration(days: index)));
    streaks.remove(now.subtract(const Duration(days: 5)));
    bool isInStreak(DateTime day) {
      for (var streakDay in streaks) {
        if (streakDay.day == day.day &&
            streakDay.month == day.month &&
            streakDay.year == day.year) {
          return true;
        }
      }
      return false;
    }

    final currentMonth =
        DateTime(now.year + monthOffset ~/ 12, now.month + monthOffset);
    final firstDayOfCurrentMonth =
        DateTime(currentMonth.year, currentMonth.month, 1);
    //get days of month
    var daysToDisplay =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    //weekdays names are in the first row
    daysToDisplay += 7;
    //add days to fill the first row
    daysToDisplay += firstDayOfCurrentMonth.weekday - 1;
    //add days to fill the last row
    daysToDisplay += (7 - (daysToDisplay % 7)) % 7;

    final tileSize = (MediaQuery.of(context).size.width -
            2 * UIConstants.pageHorizontalPadding) /
        7;

    return UICard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: tileSize / 7),
                  child: GestureDetector(
                    onDoubleTap: () => setState(() => monthOffset = 0),
                    child: Text(
                      S.of(context).month(currentMonth),
                      style:
                          UIText.titleSmall.copyWith(color: UIColors.textLight),
                    ),
                  ),
                ),
              ),
              UIIconButtonLarge(
                  icon: UIIcons.arrowUp,
                  onPressed: () => setState(() => monthOffset--)),
              const SizedBox(width: UIConstants.defaultSize),
              UIIconButtonLarge(
                  icon: UIIcons.arrowDown,
                  onPressed: () => setState(() => monthOffset++)),
            ],
          ),
          const SizedBox(height: UIConstants.itemPadding),
          SizedBox(
            height: tileSize * (daysToDisplay / 7) -
                UIConstants.defaultSize * 5 +
                UIConstants.borderWidth * (daysToDisplay / 7),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: UIConstants.borderWidth,
              ),
              itemCount: daysToDisplay, // Number of items in the grid
              itemBuilder: (context, index) {
                if (index <= 6) {
                  return Center(
                    child: Text(
                      DateFormat.EEEE(Intl.getCurrentLocale())
                          .dateSymbols
                          .STANDALONESHORTWEEKDAYS
                          .elementAt(
                              isSundayFirstDayOfWeek ? index : (index + 1) % 7),
                      style: UIText.normal.copyWith(
                        color: UIColors.textLight,
                      ),
                    ),
                  );
                } else {
                  final indexOfMonth = index - 7;
                  final dayToDisplay = firstDayOfCurrentMonth.add(
                    Duration(
                        days: indexOfMonth -
                            firstDayOfCurrentMonth.weekday +
                            (isSundayFirstDayOfWeek ? 0 : 1)),
                  );
                  final streakLeft = isInStreak(
                    dayToDisplay.subtract(const Duration(days: 1)),
                  );
                  final streakRight = isInStreak(
                    dayToDisplay.add(const Duration(days: 1)),
                  );
                  final hasStreak = isInStreak(dayToDisplay);

                  return DayTile(
                    day: dayToDisplay,
                    streakLeft: streakLeft,
                    hasStreak: hasStreak,
                    streakRight: streakRight,
                    backgroundColor: hasStreak ? UIColors.primary : null,
                    textStyle: UIText.normalBold.copyWith(
                      color: dayToDisplay == now
                          ? UIColors.primary
                          : dayToDisplay.month == currentMonth.month
                              ? hasStreak
                                  ? UIColors.textDark
                                  : UIColors.textLight
                              : UIColors.onOverlayCard,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}