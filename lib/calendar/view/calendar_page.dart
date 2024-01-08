import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/calendar/cubit/calendar_cubit.dart';
import 'package:learning_app/calendar/view/calendar_widget.dart';
import 'package:learning_app/calendar/view/streak_card.dart';
import 'package:learning_app/calendar/view/streak_saver_card.dart';
import 'package:learning_app/calendar/view/tomorrow_card.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/ui_components/widgets/ui_page.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CalendarCubit>().updateStreak();
    context.read<CalendarCubit>().updateStreakSaver();
    return const UIPage(
      appBar: UIAppBar(
        title: 'Calendar',
        leadingBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: StreakCard()),
                SizedBox(width: UIConstants.itemPaddingLarge),
                Expanded(child: StreakSaverCard()),
              ],
            ),
            SizedBox(height: UIConstants.itemPaddingLarge),
            CalendarWidget(),
            SizedBox(height: UIConstants.itemPaddingLarge),
            TomorrowCard()
          ],
        ),
      ),
    );
  }
}
