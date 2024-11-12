import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:learning_app/generated/l10n.dart';

class LearnAllCard extends StatelessWidget {
  const LearnAllCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final cardsRemaining = 0;
        final bool finishedToday = cardsRemaining == 0;

        // context
        //     .read<OverviewCubit>()
        //     .cardsRepository
        //     .getAllCardsToLearnForToday()
        //     .length;

        return UICard(
          disabled: finishedToday,
          useGradient: true,
          distanceToTop: 30,
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(
                      height: UIConstants.defaultSize,
                    ),
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
                UIIcons.arrowForwardNormal.copyWith(color: UIColors.overlay),
            ],
          ),
        );
      },
    );
  }
}
