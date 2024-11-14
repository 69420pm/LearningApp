import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button_large.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/calendar/domain/entities/time_span.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/features/calendar/domain/helper/date_time_extension.dart';
import 'package:learning_app/features/calendar/presentation/bloc/cubit/calendar_cubit.dart';
import 'package:learning_app/features/calendar/presentation/widgets/day_tile.dart';
import 'package:learning_app/generated/l10n.dart';

class MonthTile extends StatefulWidget {
  const MonthTile({super.key});

  @override
  State<MonthTile> createState() => _MonthTileState();
}

class _MonthTileState extends State<MonthTile> {
  //get from settings
  final isSundayFirstDayOfWeek = false;

  var currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
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

    return BlocBuilder<CalendarCubit, CalendarState>(
      buildWhen: (previous, current) =>
          current is CalendarLoaded || current is CalendarSaved,
      builder: (context, state) {
        return UICard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: tileSize / 7),
                      child: GestureDetector(
                        onDoubleTap: () {
                          context.read<CalendarCubit>().deleteStreaks();
                          setState(
                            () => currentMonth = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                            ),
                          );
                        },
                        child: Text(
                          S.of(context).month(currentMonth),
                          style: UIText.titleSmall
                              .copyWith(color: UIColors.textLight),
                        ),
                      ),
                    ),
                  ),
                  UIIconButtonLarge(
                    icon: UIIcons.arrowUp,
                    onPressed: () => setState(() {
                      if (currentMonth.month == 1) {
                        currentMonth = DateTime(currentMonth.year - 1, 12);
                      } else {
                        currentMonth =
                            DateTime(currentMonth.year, currentMonth.month - 1);
                      }
                    }),
                  ),
                  const SizedBox(width: UIConstants.defaultSize),
                  UIIconButtonLarge(
                    icon: UIIcons.arrowDown,
                    onPressed: () => setState(() {
                      if (currentMonth.month == 12) {
                        currentMonth = DateTime(currentMonth.year + 1, 1);
                      } else {
                        currentMonth =
                            DateTime(currentMonth.year, currentMonth.month + 1);
                      }
                    }),
                  ),
                ],
              ),
              const SizedBox(height: UIConstants.itemPadding),
              SizedBox(
                height: tileSize * (daysToDisplay / 7) -
                    UIConstants.defaultSize * 5 +
                    UIConstants.borderWidth * (daysToDisplay / 7),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
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
                              .elementAt(isSundayFirstDayOfWeek
                                  ? index
                                  : (index + 1) % 7),
                          style: UIText.normal.copyWith(
                            color: UIColors.textLight,
                          ),
                        ),
                      );
                    } else {
                      final indexOfMonth = index - 7;
                      final dayToDisplay = firstDayOfCurrentMonth.addDays(
                          indexOfMonth -
                              firstDayOfCurrentMonth.weekday +
                              (isSundayFirstDayOfWeek ? 0 : 1));
                      final streaks = context.read<CalendarCubit>().streaks;
                      final streakLeft = streaks.contains(
                        dayToDisplay.dayBefore(),
                      );
                      final streakRight = streaks.contains(
                        dayToDisplay.dayAfter(),
                      );
                      final hasStreak = streaks.contains(dayToDisplay);

                      return DayTile(
                        day: dayToDisplay,
                        streakLeft: streakLeft,
                        hasStreak: hasStreak,
                        streakRight: streakRight,
                        backgroundColor: hasStreak ? UIColors.primary : null,
                        textStyle: UIText.normalBold.copyWith(
                          color: dayToDisplay.isToday()
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
      },
    );
  }
}
