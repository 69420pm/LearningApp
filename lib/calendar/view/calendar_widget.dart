// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/calendar/cubit/calendar_cubit.dart';
import 'package:learning_app/calendar/view/day.dart';
import 'package:learning_app/calendar_backend/calendar_api/models/calendar_day.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/ui_components/widgets/ui_container.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentDateTime = DateTime.now();
    return UIContainer(
      child: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          final calendarDateTime = (state as CalendarShowMonth).dateTime;
          return FutureBuilder(
            future: _getDaysInMonth(
              calendarDateTime.year,
              calendarDateTime.month,
              context,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final daysOfMonthDayTimes = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat.MMMM().format(calendarDateTime),
                          style: UIText.titleBig,
                        ),
                        Row(
                          children: [
                            UIIconButton(
                              icon: UIIcons.arrowBackNormal,
                              onPressed: () {
                                context.read<CalendarCubit>().changeMonthDown();
                              },
                            ),
                            UIIconButton(
                              icon: UIIcons.arrowForwardNormal,
                              onPressed: () {
                                context.read<CalendarCubit>().changeMonthUp();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Visibility(
                      visible: currentDateTime.year != calendarDateTime.year,
                      child: Column(
                        children: [
                          Text(
                            calendarDateTime.year.toString(),
                            style: UIText.label,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: UIConstants.itemPadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 31,
                          child: Center(
                            child: Text(
                              'Mon',
                              style: UIText.normal
                                  .copyWith(color: UIColors.smallText),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 31,
                          child: Center(
                            child: Text(
                              'Tue',
                              style: UIText.normal
                                  .copyWith(color: UIColors.smallText),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 31,
                          child: Center(
                            child: Text(
                              'Wed',
                              style: UIText.normal
                                  .copyWith(color: UIColors.smallText),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 31,
                          child: Center(
                            child: Text(
                              'Thu',
                              style: UIText.normal
                                  .copyWith(color: UIColors.smallText),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 31,
                          child: Center(
                            child: Text(
                              'Fri',
                              style: UIText.normal
                                  .copyWith(color: UIColors.smallText),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 31,
                          child: Center(
                            child: Text(
                              'Sat',
                              style: UIText.normal
                                  .copyWith(color: UIColors.smallText),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 31,
                          child: Center(
                            child: Text(
                              'Sun',
                              style: UIText.normal
                                  .copyWith(color: UIColors.smallText),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 220,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: daysOfMonthDayTimes.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7, // Number of columns
                          crossAxisSpacing: 0, // Spacing between columns
                          mainAxisSpacing: 0, // Spacing between rows
                        ),
                        itemBuilder: (context, index) {
                          return daysOfMonthDayTimes[index];
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        },
      ),
    );
  }

  Future<List<Day>> _getDaysInMonth(
    int year,
    int month,
    BuildContext context,
  ) async {
    final currentDate = DateTime(year, month);
    final days = <Day>[];
    final calendarDays = <int, CalendarDay>{};
    var iterableDate =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));
    CalendarDay? calendarDay;
    // add days in month
    for (var i = 0; i < 35; i++) {
      var streakType = StreakType.none;
      if (calendarDays[i] == null) {
        calendarDay =
            await context.read<CalendarCubit>().getCalendarDay(iterableDate);
      }
      if (calendarDay != null && calendarDay.streakCompleted) {
        calendarDays[i] = calendarDay;

        final previousDay = i > 0
            ? calendarDays[i - 1]
            : await context
                .read<CalendarCubit>()
                .getCalendarDay(iterableDate.subtract(const Duration(days: 1)));
        // previous completed
        if (previousDay != null && previousDay.streakCompleted) {
          final nextDay = await context
              .read<CalendarCubit>()
              .getCalendarDay(iterableDate.add(const Duration(days: 1)));
          if (nextDay != null) {
            calendarDays[i + 1] = nextDay;
            if (nextDay.streakCompleted) {
              streakType = StreakType.streakInBetween;
            }
          } else {
            streakType = StreakType.streakEnd;
          }
        }
        // previous not completed
        else {
          final nextDay = await context
              .read<CalendarCubit>()
              .getCalendarDay(iterableDate.add(const Duration(days: 1)));
          if (nextDay != null) {
            calendarDays[i + 1] = nextDay;
            if (nextDay.streakCompleted) {
              streakType = StreakType.streakStart;
            } else {
              streakType = StreakType.singleStreak;
            }
          } else {
            streakType = StreakType.singleStreak;
          }
        }
      }
      days.add(
        Day(
          dateTime: iterableDate,
          active: currentDate.month == iterableDate.month,
          streakType: streakType,
        ),
      );
      iterableDate = iterableDate.add(const Duration(days: 1));
    }
    return days;
  }
}

enum StreakType { none, streakStart, streakInBetween, streakEnd, singleStreak }
