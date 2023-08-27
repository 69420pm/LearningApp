import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';
import 'package:ui_components/ui_components.dart';

class PageWeekdayPicker extends StatelessWidget {
  PageWeekdayPicker({super.key, required this.subject});

  Subject subject;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditSubjectCubit, EditSubjectState>(
      buildWhen: (previous, current) => current is EditSubjectUpdateWeekdays,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
            color: UIColors.overlay,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: UIConstants.itemPadding * 0.75,
              horizontal: UIConstants.itemPaddingLarge,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _WeekDay(
                  text: 'Mon',
                  id: 0,
                  subject: subject,
                  isSelected: state is EditSubjectUpdateWeekdays
                      ? state.selectedDays[0]
                      : false,
                ),
                _WeekDay(
                  text: 'Tue',
                  subject: subject,
                  id: 1,
                  isSelected: state is EditSubjectUpdateWeekdays
                      ? state.selectedDays[1]
                      : false,
                ),
                _WeekDay(
                  text: 'Wed',
                  id: 2,
                  subject: subject,
                  isSelected: state is EditSubjectUpdateWeekdays
                      ? state.selectedDays[2]
                      : false,
                ),
                _WeekDay(
                  text: 'Thu',
                  id: 3,
                  subject: subject,
                  isSelected: state is EditSubjectUpdateWeekdays
                      ? state.selectedDays[3]
                      : false,
                ),
                _WeekDay(
                  text: 'Fri',
                  id: 4,
                  subject: subject,
                  isSelected: state is EditSubjectUpdateWeekdays
                      ? state.selectedDays[4]
                      : false,
                ),
                _WeekDay(
                  text: 'Sat',
                  id: 5,
                  subject: subject,
                  isSelected: state is EditSubjectUpdateWeekdays
                      ? state.selectedDays[5]
                      : false,
                ),
                _WeekDay(
                  text: 'Sun',
                  id: 6,
                  subject: subject,
                  isSelected: state is EditSubjectUpdateWeekdays
                      ? state.selectedDays[6]
                      : false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WeekDay extends StatelessWidget {
  _WeekDay({
    super.key,
    required this.text,
    required this.id,
    required this.isSelected,
    required this.subject
  });

  String text;
  int id;
  bool isSelected;
  Subject subject;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(UIConstants.cornerRadiusSmall),
          ),
          color: isSelected ? UIColors.primary : UIColors.background,
        ),
        child: Center(
          child: Text(
            text,
            style: isSelected
                ? UIText.normalBold.copyWith(color: UIColors.textDark)
                : UIText.normal,
          ),
        ),
      ),
      onTap: () {
        context.read<EditSubjectCubit>().updateWeekdays(id, subject);
      },
    );
  }
}
