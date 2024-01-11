import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/overview/cubit/overview_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/ui_card.dart';

class LearnAllCard extends StatelessWidget {
  const LearnAllCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewCubit, OverviewCubitState>(
      buildWhen: (previous, current) => current is UpdateLearnAllButtonState,
      builder: (context, state) {
        return FutureBuilder(
          future: context.read<LearnCubit>().loadTodaysCards(),
          builder: (context, cardsToLearn) {
            return UICard(
              useGradient: true,
              distanceToTop: 80,
              color: UIColors.primary,
              onTap: () => Navigator.pushNamed(context, "/learn").then(
                  (value) =>
                      context.read<OverviewCubit>().updateLearnAllButton()),
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
                        style:
                            UIText.titleBig.copyWith(color: UIColors.textDark),
                      ),
                      const SizedBox(
                        height: UIConstants.defaultSize,
                      ),
                      Text(
                        cardsToLearn.connectionState == ConnectionState.done
                            ? '${cardsToLearn.data!.length} Cards remaining'
                            : 'loading',
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
      },
    );
  }
}
