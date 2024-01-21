import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';

class RateBar extends StatelessWidget {
  const RateBar({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RateButton(
          feedback: LearnFeedback.good,
          index: index,
        ),
        RateButton(
          feedback: LearnFeedback.medium,
          index: index,
        ),
        RateButton(
          feedback: LearnFeedback.bad,
          index: index,
        ),
      ],
    );
  }
}

class RateButton extends StatelessWidget {
  RateButton({super.key, required this.feedback, required this.index});
  final int index;
  final LearnFeedback feedback;

  final icons = [UIIcons.add, UIIcons.curlyBraces, UIIcons.debug];
  final colors = [UIColors.green, UIColors.yellow, UIColors.red];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UIConstants.defaultSize * 8,
      width: UIConstants.defaultSize * 8,
      decoration: BoxDecoration(color: colors[feedback.index]),
      child: UIIconButton(
        textColor: UIColors.textDark,
        icon: icons[feedback.index].copyWith(color: UIColors.textDark),
        onPressed: () {
          context.read<LearnCubit>().rateCard(feedback, index);
        },
      ),
    );
  }
}
