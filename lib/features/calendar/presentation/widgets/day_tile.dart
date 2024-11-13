import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/features/calendar/domain/helper/date_time_extension.dart';
import 'package:learning_app/features/calendar/presentation/bloc/cubit/streak_cubit.dart';

class DayTile extends StatelessWidget {
  const DayTile({
    super.key,
    required this.day,
    required this.streakLeft,
    required this.hasStreak,
    required this.streakRight,
    this.textStyle,
    this.backgroundColor,
  });

  final DateTime day;
  final bool streakLeft;
  final bool hasStreak;
  final bool streakRight;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    const border = BorderSide(
      color: UIColors.background,
      width: UIConstants.borderWidth,
    );
    return GestureDetector(
      onTap: () => context.read<StreakCubit>().addDayToStreaks(day),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
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
              color: day.isToday() ? UIColors.background : Colors.transparent,
              borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: textStyle ??
                    UIText.normalBold.copyWith(
                      color:
                          day.isToday() ? UIColors.primary : UIColors.textDark,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
