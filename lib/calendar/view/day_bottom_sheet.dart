import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/calendar/cubit/calendar_cubit.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';
import 'package:learning_app/edit_subject/view/class_test_list_tile.dart';
import 'package:learning_app/overview/view/subject_list_tile.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/ui_components/widgets/ui_description.dart';
import 'package:learning_app/ui_components/widgets/ui_label_row.dart';

class DayBottomSheet extends StatelessWidget {
  const DayBottomSheet({
    super.key,
    required this.dateTime,
    required this.classTests,
    required this.subjects,
  });
  final DateTime dateTime;
  final List<Subject> subjects;
  final Map<Subject, List<ClassTest>> classTests;
  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      title: Text(
        '${DateFormat.E().format(dateTime)} ${DateFormat.MMM().format(dateTime)} ${DateFormat.d().format(dateTime)} ${DateFormat.y().format(dateTime)}',
        style: UIText.label,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UILabelRow(
            labelText: 'Exams',
          ),
          const SizedBox(height: UIConstants.itemPadding),
          Builder(
            builder: (context) {
              if (classTests.isEmpty) {
                return Text(
                  'no exams scheduled on this day',
                  style: UIText.normal.copyWith(color: UIColors.smallText),
                );
              } else {
                return BlocBuilder<CalendarCubit, CalendarState>(
                  buildWhen: (previous, current) =>
                      current is CalendarClassTestChanged,
                  builder: (context, state) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: classTests.keys.length,
                      itemBuilder: (context, index) {
                        final currentKey = classTests.keys.toList()[index];
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: classTests[currentKey]!.length,
                          itemBuilder: (context, i) {
                            return ClassTestListTile(
                              classTest: classTests[currentKey]![i],
                              subject: currentKey,
                              classTestChanged: () {
                                context.read<CalendarCubit>().changeClassTest(
                                      classTests[currentKey]![i],
                                    );
                                    Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
                // return ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: classTests.length,
                //   itemBuilder: (context, index) {
                //     // final a = classTests[classTests.keys.toList()[index]];
                //     // if(classTests[classTests.keys.toList()[index]] == null){
                //     //   return Container();
                //     // }
                //     return ListView.builder(
                //       shrinkWrap: true,
                //       itemCount: classTests.values.toList()[index].length,
                //       itemBuilder: (_, i) {
                //         if (classTests[classTests.keys.toList()[index]] ==
                //             null) {
                //           return Container();
                //         }
                //         return ClassTestListTile(
                //             subject: classTests.keys.toList()[index],
                //             classTest: classTests[
                //                 classTests.values.toList()[index]]![i]);
                //       },
                //     );
                //   },
                // );
              }
            },
          ),
          const SizedBox(height: UIConstants.itemPaddingLarge),
          const UILabelRow(
            labelText: 'Subjects',
          ),
          const SizedBox(height: UIConstants.itemPadding),
          Builder(
            builder: (context) {
              if (subjects.isEmpty) {
                return Text(
                  'no subjects scheduled on this day',
                  style: UIText.normal.copyWith(color: UIColors.smallText),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return SubjectListTile(
                    subject: subjects[index],
                    classTests: context
                        .read<CalendarCubit>()
                        .getClassTests()[subjects[index]],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
