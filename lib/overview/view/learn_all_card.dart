import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/ui_card.dart';

class LearnAllCard extends StatelessWidget {
  const LearnAllCard({super.key});

  @override
  Widget build(BuildContext context) {
    print("moin");
    return FutureBuilder(
      future: context.read<LearnCubit>().loadTodaysCards(),
      builder: (context, cardsToLearn) {
        return UICard(
          useGradient: true,
          distanceToTop: 80,
          color: UIColors.primary,
          onTap: () => Navigator.pushNamed(context, "/learn"),
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
                    '${cardsToLearn.data?.length ?? -1} Cards remaining',
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
