import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';

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
    final now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final bool isToday = now == day;
    const border = BorderSide(
      color: UIColors.background,
      width: UIConstants.borderWidth,
    );
    return Container(
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
            color: isToday ? UIColors.background : Colors.transparent,
            borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
          ),
          child: Center(
            child: Text(
              day.day.toString(),
              style: textStyle ??
                  UIText.normalBold.copyWith(
                    color: isToday ? UIColors.primary : UIColors.textDark,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
