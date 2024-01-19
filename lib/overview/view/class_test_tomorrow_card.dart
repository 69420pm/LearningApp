import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/calendar/cubit/calendar_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/ui_card.dart';

class ClassTestTomorrowCard extends StatelessWidget {
  const ClassTestTomorrowCard({super.key});

  @override
  Widget build(BuildContext context) {
    final classTestsTomorrow =
        context.read<CalendarCubit>().getClassTestsByDate(
              DateTime.now().add(const Duration(days: 1)),
            );
    if (classTestsTomorrow.isEmpty) {
      return Container();
    } else {
      var classTestString = '';
      for (int i = 0; i < classTestsTomorrow.length; i++) {
        classTestString += classTestsTomorrow[i].name;
        if (i != classTestsTomorrow.length - 1) {
          classTestString += ',';
        }
        classTestString += ' ';
      }
      if (classTestsTomorrow.length > 1) {
        classTestString += 'class tests tomorrow';
      } else {
        classTestString += 'class test tomorrow';
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UICard(
            color: UIColors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Flexible(
                      child: Text(
                        'Class Test Tomorrow',
                        style: UIText.titleBig,
                      ),
                    ),
                    UIIcons.arrowForwardNormal,
                  ],
                ),
                const SizedBox(height: UIConstants.itemPadding),
                Text(
                  'Good luck with your $classTestString',
                  style: UIText.label,
                ),
              ],
            ),
          ),
          const SizedBox(height: UIConstants.itemPaddingLarge),
        ],
      );
    }
  }
}
