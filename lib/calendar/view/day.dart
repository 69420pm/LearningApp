import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/calendar/cubit/calendar_cubit.dart';
import 'package:learning_app/calendar/view/calendar_widget.dart';
import 'package:learning_app/calendar/view/day_bottom_sheet.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';

class Day extends StatelessWidget {
  Day({
    super.key,
    required this.dateTime,
    required this.isActive,
    required this.streakType,
    required this.classTests,
    required this.subjects
  });
  DateTime dateTime;
  bool isActive;
  StreakType streakType;
  Map<Subject, List<ClassTest>> classTests;
  List<Subject> subjects;

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    bool isToday = dateTime.year == currentDate.year &&
        dateTime.month == currentDate.month &&
        dateTime.day == currentDate.day;
    // Size size = (context.findRenderObject() as RenderBox).size;
    // Size size = const Size(43, 43);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        UIBottomSheet.showUIBottomSheet(
            context: context,
            builder: (_) => BlocProvider.value(
                  value: context.read<CalendarCubit>(),
                  child: DayBottomSheet(
                    dateTime: dateTime,
                    classTests: classTests,
                    subjects: subjects
                  ),
                )).then(
          (value) {
            // context
            //     .read<CalendarCubit>()
            //     .changeDate(dateTime.add(const Duration(seconds: 1)));
          },
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (isToday) {
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
                          height: 4,
                        ),
                        Text(
                          dateTime.day.toString(),
                          style: UIText.normalBold
                              .copyWith(color: UIColors.background),
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
          } else {
            bool isClassTest = classTests != null && classTests!.isNotEmpty;
            var textColor = UIColors.textLight;
            if (isActive && isClassTest) {
              textColor = UIColors.textDark;
            } else if (!isActive) {
              if (isClassTest) {
                textColor = UIColors.textDark;
              } else {
                textColor = UIColors.smallText;
              }
            }
            return Stack(
              children: [
                Visibility(
                  visible: isClassTest,
                  child: Positioned(
                    top: constraints.maxHeight / 2 - 11,
                    left: constraints.maxWidth / 2 - 11,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: isActive
                            ? UIColors.primary
                            : UIColors.primaryDisabled,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: constraints.maxHeight / 2 - 15,
                  left: constraints.maxWidth / 2 - 15,
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: Text(
                        dateTime.day.toString(),
                        style: UIText.normal.copyWith(color: textColor),
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
          }
        },
      ),
    );
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
