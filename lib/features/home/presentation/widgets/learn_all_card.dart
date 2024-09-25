import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/home/presentation/bloc/home_bloc.dart';

class LearnAllCard extends StatelessWidget {
  const LearnAllCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      // buildWhen: (previous, current) => current is UpdateLearnAllButtonState,
      builder: (context, state) {
        final cardsRemaining = 69;

        // context
        //     .read<OverviewCubit>()
        //     .cardsRepository
        //     .getAllCardsToLearnForToday()
        //     .length;

        if (cardsRemaining == 0) {
          return UICard(
            disabled: true,
            useGradient: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Finished Today',
                  style: UIText.titleBig.copyWith(color: UIColors.textLight),
                  overflow: TextOverflow.fade,
                ),
                const SizedBox(
                  height: UIConstants.defaultSize,
                ),
                Text(
                  'Have a nice day!',
                  style: UIText.label.copyWith(
                    color: UIColors.textLight,
                  ),
                ),
              ],
            ),
          );
        }
        return UICard(
          useGradient: true,
          distanceToTop: 30,
          color: UIColors.primary,
          onTap: () {
            // Navigator.pushNamed(context, "/learn", arguments: ["today"]).then(
            //       (value) =>
            //           context.read<OverviewCubit>().updateLearnAllButton());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learn All',
                    style: UIText.titleBig.copyWith(color: UIColors.textDark),
                  ),
                  const SizedBox(
                    height: UIConstants.defaultSize,
                  ),
                  Text(
                    '${cardsRemaining ?? "?"} cards remaining',
                    style: UIText.label.copyWith(
                      color: UIColors.textDark,
                    ),
                  ),
                ],
              ),
              UIIcons.arrowForwardNormal.copyWith(color: UIColors.overlay),
            ],
          ),
        );
      },
    );
  }
}
