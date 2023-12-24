import 'package:flutter/material.dart';
import 'package:learning_app/calendar/view/calendar_widget.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_text.dart';

class Day extends StatelessWidget {
  Day({
    super.key,
    required this.dateTime,
    required this.active,
    required this.streakType,
  });
  DateTime dateTime;
  bool active;
  StreakType streakType;

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    bool today = dateTime.year == currentDate.year &&
        dateTime.month == currentDate.month &&
        dateTime.day == currentDate.day;
    // Size size = (context.findRenderObject() as RenderBox).size;
    // Size size = const Size(43, 43);

    if (today) {
      return LayoutBuilder(

        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                top: constraints.maxHeight / 2 - 18,
                left: constraints.maxWidth / 2 - 18,
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: UIColors.primary,
                  ),
                ),
              ),
              Positioned(
                top: constraints.maxHeight / 2 - 15,
                left: constraints.maxWidth / 2 - 15,
                child: Container(
                  height: 30,
                  width: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        dateTime.day.toString(),
                        style:
                            UIText.normalBold.copyWith(color: UIColors.background),
                      ),
                      Container(
                        height: 4,
                        width: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: UIColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                top: constraints.maxHeight / 2 - 15,
                left: constraints.maxWidth / 2 - 15,
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Text(
                      dateTime.day.toString(),
                      style: active
                          ? UIText.normal
                          : UIText.normal.copyWith(color: UIColors.smallText),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: constraints.maxHeight / 2 - 15,
                left: 0,
                right: 0,
                child: _StreakBorder(
                  streakType: streakType,
                ),
              ),
            ],
          );
        },
      );
    }
  }
}

class _StreakBorder extends StatelessWidget {
  _StreakBorder({super.key, required this.streakType});
  StreakType streakType;
  @override
  Widget build(BuildContext context) {
    if (streakType == StreakType.streakEnd) {
      return Container(
        height: 30,
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 3, color: UIColors.primary), // Top border
            right: BorderSide(width: 3, color: UIColors.primary), // Left border
            bottom:
                BorderSide(width: 3, color: UIColors.primary), // Right border
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(100),
            bottomRight: Radius.circular(100),
          ),
        ),
      );
    } else if (streakType == StreakType.streakStart) {
      return Container(
        height: 30,
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 3, color: UIColors.primary), // Top border
            left: BorderSide(width: 3, color: UIColors.primary), // Left border
            bottom:
                BorderSide(width: 3, color: UIColors.primary), // Right border
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100),
            bottomLeft: Radius.circular(100),
          ),
        ),
      );
    } else if (streakType == StreakType.streakInBetween) {
      return Container(
        height: 30,
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 3, color: UIColors.primary), // Top border
            bottom:
                BorderSide(width: 3, color: UIColors.primary), // Right border
          ),
        ),
      );
    } else if (streakType == StreakType.singleStreak) {
      return Container(
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(
            width: 3, color: UIColors.primary, // Top border
            // Right border
          ),
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
      );
    }
    return Container();
  }
}