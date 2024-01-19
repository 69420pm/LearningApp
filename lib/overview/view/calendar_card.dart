import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/calendar/cubit/calendar_cubit.dart';
import 'package:learning_app/calendar/view/calendar_widget.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/ui_card.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    final classTests = context.read<CalendarCubit>().getClassTests();
    final calendarDateTime = context.read<CalendarCubit>().currentMonth;
    final classTestsThisMonth = <Subject, List<ClassTest>>{};
    classTests.forEach((subject, classTests) {
      for (final classTest in classTests) {
        if (classTest.date.year == calendarDateTime.year &&
                classTest.date.month == calendarDateTime.month ||
            classTest.date.month == calendarDateTime.month - 1 ||
            classTest.date.month == calendarDateTime.month + 1) {
          if (classTestsThisMonth[subject] == null) {
            classTestsThisMonth[subject] = [classTest];
          } else {
            classTestsThisMonth[subject]!.add(classTest);
          }
        }
      }
    });
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/calendar'),
      child: UICard(
        useGradient: true,
        distanceToTop: 280,
        color: UIColors.primary,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calendar',
                      style: UIText.titleBig.copyWith(color: UIColors.textDark),
                    ),
                    const SizedBox(
                      height: UIConstants.defaultSize,
                    ),
                    Text(
                      DateFormat('EEEE, MMMM dd').format(DateTime.now()),
                      // "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}",
                      style: UIText.label.copyWith(
                        color: UIColors.textDark,
                      ),
                    ),
                  ],
                ),
                UIIcons.arrowForwardNormal.copyWith(color: UIColors.overlay),
              ],
            ),
            const SizedBox(
              height: UIConstants.itemPadding,
            ),
            CalendarWidget(
              showWeek: true,
            ),
            // SizedBox(
            //   width: double.infinity,
            //   height: 64,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemCount: 7,
            //     itemBuilder: (context, index) => DayTile(index: index),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
