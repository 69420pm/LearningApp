import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/calendar/cubit/calendar_cubit.dart';
import 'package:learning_app/calendar/view/calendar_widget.dart';
import 'package:learning_app/calendar/view/streak_card.dart';
import 'package:learning_app/calendar/view/streak_saver_card.dart';
import 'package:learning_app/calendar/view/tomorrow_card.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/ui_components/widgets/ui_container.dart';
import 'package:learning_app/ui_components/widgets/ui_page.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CalendarCubit>().updateStreak();
    context.read<CalendarCubit>().updateStreakSaver();
    return UIPage(
      appBar: const UIAppBar(
        title: 'Calendar',
        leadingBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: StreakCard()),
                SizedBox(width: UIConstants.itemPaddingLarge),
                Expanded(child: StreakSaverCard()),
              ],
            ),
            const SizedBox(height: UIConstants.itemPaddingLarge),
            UIContainer(child: CalendarWidget()),
            const SizedBox(height: UIConstants.itemPaddingLarge),
            const TomorrowCard()
          ],
        ),
      ),
    );
  }
}
