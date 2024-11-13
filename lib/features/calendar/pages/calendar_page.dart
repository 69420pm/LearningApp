import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/calendar/widgets/month_tile.dart';
import 'package:learning_app/features/calendar/widgets/streak_saver_tile.dart';
import 'package:learning_app/features/calendar/widgets/streak_tile.dart';
import 'package:learning_app/features/calendar/widgets/tomorrow_tile.dart';
import 'package:learning_app/features/home/presentation/widgets/week_row.dart';
import 'package:learning_app/generated/l10n.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIAppBar(
        title: S.of(context).calendar,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIConstants.pageHorizontalPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: StreakTile(),
                  ),
                  SizedBox(width: UIConstants.itemPadding),
                  Expanded(
                    flex: 3,
                    child: StreakSaverTile(),
                  ),
                ],
              ),
              SizedBox(height: UIConstants.itemPadding),
              TomorrowTile(),
              SizedBox(height: UIConstants.itemPadding),
              MonthTile(),
            ],
          ),
        ),
      ),
    );
  }
}
