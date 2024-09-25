import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class WeekdayPicker extends StatelessWidget {
  const WeekdayPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSubjectCubit, AddSubjectState>(
      buildWhen: (previous, current) => current is AddSubjectUpdateWeekdays,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _WeekDay(
              text: 'Mon',
              id: 0,
              isSelected: state is AddSubjectUpdateWeekdays? state.selectedDays[0]:false,
            ),
            _WeekDay(
              text: 'Tue',
              id: 1,
              isSelected: state is AddSubjectUpdateWeekdays? state.selectedDays[1]:false,
            ),
            _WeekDay(
              text: 'Wed',
              id: 2,
              isSelected: state is AddSubjectUpdateWeekdays? state.selectedDays[2]:false,
            ),
            _WeekDay(
              text: 'Thu',
              id: 3,
              isSelected: state is AddSubjectUpdateWeekdays? state.selectedDays[3]:false,
            ),
            _WeekDay(
              text: 'Fri',
              id: 4,
              isSelected: state is AddSubjectUpdateWeekdays? state.selectedDays[4]:false,
            ),
            _WeekDay(
              text: 'Sat',
              id: 5,
              isSelected: state is AddSubjectUpdateWeekdays? state.selectedDays[5]:false,
            ),
            _WeekDay(
              text: 'Sun',
              id: 6,
              isSelected: state is AddSubjectUpdateWeekdays? state.selectedDays[6]:false,
            ),
          ],
        );
      },
    );
  }
}

class _WeekDay extends StatelessWidget {
  _WeekDay({
    required this.text,
    required this.id,
    required this.isSelected,
  });

  String text;
  int id;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(UIConstants.cornerRadiusSmall),
          ),
          color: isSelected ? UIColors.primary : UIColors.onOverlayCard,
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
        context.read<AddSubjectCubit>().updateWeekdays(id);
      },
    );
  }
}
