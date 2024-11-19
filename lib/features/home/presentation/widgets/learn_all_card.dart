import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/core/app_router.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/calendar/domain/entities/calendar.dart';
import 'package:learning_app/features/calendar/domain/helper/date_time_extension.dart';
import 'package:learning_app/features/calendar/presentation/bloc/cubit/calendar_cubit.dart';
import 'package:learning_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:learning_app/features/home/presentation/widgets/week_row.dart';
import 'package:learning_app/generated/l10n.dart';

class LearnAllCard extends StatelessWidget {
  const LearnAllCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        //get from database
        final cardsRemaining = 1000;

        final bool finishedToday = cardsRemaining == 0;

        return UICard(
          disabled: finishedToday,
          useGradient: true,
          distanceToTop: 30,
          onTap: () =>
              context.push(context.namedLocation(AppRouteName.learn.name)).then(
                    (value) => context
                        .read<CalendarCubit>()
                        .addDayToStreaks(DateTime.now()),
                  ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).learnCardTitle(cardsRemaining),
                      style: UIText.titleBig.copyWith(
                          color: finishedToday
                              ? UIColors.textLight
                              : UIColors.textDark),
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: UIConstants.defaultSize),
                    Text(
                      S.of(context).learnCardSubTitle(cardsRemaining),
                      style: UIText.label.copyWith(
                        color: finishedToday
                            ? UIColors.textLight
                            : UIColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              if (!finishedToday)
                UIIcons.arrowForwardNormal.copyWith(color: UIColors.textDark),
            ],
          ),
        );
      },
    );
  }
}
