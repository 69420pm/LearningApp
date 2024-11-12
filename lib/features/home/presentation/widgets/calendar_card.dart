import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/home/presentation/widgets/calendar_widget.dart';
import 'package:learning_app/generated/l10n.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/calendar'),
      child: UICard(
        useGradient: true,
        distanceToTop: 280,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).calendarTitle,
                      style: UIText.titleBig.copyWith(color: UIColors.textDark),
                    ),
                    const SizedBox(height: UIConstants.defaultSize),
                    Text(
                      S.of(context).month(DateTime.now()),
                      style: UIText.label.copyWith(
                        color: UIColors.textDark,
                      ),
                    ),
                  ],
                ),
                UIIcons.arrowForwardNormal.copyWith(color: UIColors.textDark),
              ],
            ),
            const SizedBox(
              height: UIConstants.itemPadding,
            ),
            const WeekRow(),
          ],
        ),
      ),
    );
  }
}
