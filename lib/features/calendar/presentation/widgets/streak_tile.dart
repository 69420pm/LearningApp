import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/calendar/domain/entities/time_span.dart';
import 'package:learning_app/features/calendar/presentation/bloc/cubit/streak_cubit.dart';
import 'package:learning_app/generated/l10n.dart';

class StreakTile extends StatelessWidget {
  const StreakTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreakCubit, StreakState>(
      builder: (context, state) {
        return UICard(
          useGradient: true,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context
                      .read<StreakCubit>()
                      .streaks
                      .currentStreakLength()
                      .toString(),
                  style: UIText.titleBig.copyWith(color: UIColors.textDark),
                  overflow: TextOverflow.fade,
                ),
                const SizedBox(height: UIConstants.defaultSize),
                Text(
                  S.of(context).dayStreak,
                  style: UIText.label.copyWith(
                    color: UIColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
