import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/calendar/cubit/calendar_cubit.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/edit_subject/view/class_test_list_tile.dart';
import 'package:learning_app/overview/view/subject_list_tile.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/progress_indicators/ui_circular_progress_indicator.dart';
import 'package:learning_app/ui_components/widgets/ui_card.dart';

class TomorrowCard extends StatelessWidget {
  const TomorrowCard({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectsMappedToWeekDay =
        context.read<CalendarCubit>().getSubjectsMappedToWeekday();
    final tomorrow = DateTime.now().add(Duration(days: 1));
    final subjects = subjectsMappedToWeekDay[tomorrow.weekday] ?? [];
    return UICard(
      child: BlocBuilder<CalendarCubit, CalendarState>(
        buildWhen: (previous, current) => current is CalendarClassTestChanged,
        builder: (context, state) {
          List<ClassTest> classTestsTomorrow =
              context.read<CalendarCubit>().getClassTestsByDate(tomorrow);
          return Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tomorrow', style: UIText.titleBig),
                  // UIIcons.arrowForwardNormal.copyWith(color: UIColors.textLight),
                ],
              ),
              const SizedBox(
                height: UIConstants.itemPadding,
              ),
              ListView.builder(
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
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: classTestsTomorrow.length,
                itemBuilder: (context, index) {
                  return ClassTestListTile(
                    classTest: classTestsTomorrow[index],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
