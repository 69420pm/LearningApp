import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button_large.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/calendar/presentation/bloc/cubit/calendar_cubit.dart';
import 'package:learning_app/generated/l10n.dart';

class StreakSaverTile extends StatelessWidget {
  const StreakSaverTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //get from database
    const streakSaver = 2;
    const maxStreakSaver = 3;

    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return UICard(
          useGradient: false,
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
                      "${context.read<CalendarCubit>().streakSaver}/${context.read<CalendarCubit>().maxStreakSaver}",
                      style:
                          UIText.titleBig.copyWith(color: UIColors.textLight),
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: UIConstants.defaultSize),
                    Text(
                      S.of(context).streakSaver,
                      style: UIText.label.copyWith(
                        color: UIColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              UIIconButtonLarge(
                icon: UIIcons.add.copyWith(color: UIColors.primary),
                onPressed: () {
                  context.read<CalendarCubit>().addStreakSaver();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
