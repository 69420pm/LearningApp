import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/calendar/cubit/calendar_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/ui_card.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    return UICard(
      useGradient: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<CalendarCubit, CalendarState>(
            buildWhen: (previous, current) => current is CalendarStreakChanged,
            builder: (context, state) {
              if (state is CalendarStreakChanged) {
                return Text(state.streak.toString(),
                    style: UIText.titleBig.copyWith(color: UIColors.textDark));
              } else {
                return Text("---");
              }
            },
          ),
          Text('day streak',
              style: UIText.label.copyWith(color: UIColors.textDark))
        ],
      ),
    );
  }
}
