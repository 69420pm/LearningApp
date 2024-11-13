import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/features/calendar/domain/entities/streak.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/features/calendar/domain/helper/date_time_extension.dart';
import 'package:learning_app/features/calendar/presentation/bloc/cubit/streak_cubit.dart';
import 'package:learning_app/features/calendar/presentation/widgets/day_tile.dart';

class WeekRow extends StatelessWidget {
  const WeekRow({super.key});

  @override
  Widget build(BuildContext context) {
    //get from settings
    const isSundayFirstDayOfWeek = false;

    final now = DateTime.now().onlyDay();
    final firstDayOfCurrentWeek = now.subtract(
        Duration(days: now.weekday - (isSundayFirstDayOfWeek ? 0 : 1)));

    context.read<StreakCubit>().getStreaks();

    return BlocBuilder<StreakCubit, StreakState>(
      builder: (context, state) {
        final streaks = context.read<StreakCubit>().streaks;
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
                    final day =
                        firstDayOfCurrentWeek.add(Duration(days: index));
                    final streakLeft = streaks.contains(
                      day.dayBefore(),
                    );
                    final streakRight = streaks.contains(
                      day.dayAfter(),
                    );
                    final hasStreak = streaks.contains(day);

                    //Expanded doesn't work with ListView.builder, so List.generate is used
                    return Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: UIConstants.defaultSize * 3,
                            child: Center(
                              child: Text(
                                DateFormat.EEEE(Intl.getCurrentLocale())
                                    .dateSymbols
                                    .STANDALONESHORTWEEKDAYS
                                    .elementAt(
                                        day.weekday > 6 ? 0 : day.weekday),
                                style: UIText.normal.copyWith(
                                  color: UIColors.textDark,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: DayTile(
                              day: day,
                              streakLeft: streakLeft,
                              hasStreak: hasStreak,
                              streakRight: streakRight,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
