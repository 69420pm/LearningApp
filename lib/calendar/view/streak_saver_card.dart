import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/calendar/cubit/calendar_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button_large.dart';
import 'package:learning_app/ui_components/widgets/ui_card.dart';

class StreakSaverCard extends StatelessWidget {
  const StreakSaverCard({super.key});

  @override
  Widget build(BuildContext context) {
    return UICard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<CalendarCubit, CalendarState>(
            buildWhen: (previous, current) =>
                current is CalendarStreakSaverChanged,
            builder: (context, state) {
              var streakSaver = 0;
              if (state is CalendarStreakSaverChanged) {
                streakSaver = state.streakSaver;
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$streakSaver/2',
                    style: UIText.titleBig.copyWith(color: UIColors.textLight),
                  ),
                  UIIconButtonLarge(
                    icon: UIIcons.add.copyWith(color: UIColors.primary),
                    onPressed: () {
                      context.read<CalendarCubit>().addStreakSaver(1);
                    },
                  ),
                ],
              );
            },
          ),
          Text(
            'streak saver',
            style: UIText.label.copyWith(color: UIColors.textLight),
          ),
        ],
      ),
    );
  }
}
