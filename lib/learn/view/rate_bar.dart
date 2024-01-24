import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';

class RateBar extends StatefulWidget {
  RateBar({super.key, required this.index, required this.feedback});

  final int index;
  LearnFeedback feedback;

  @override
  State<RateBar> createState() => _RateBarState();
}

class _RateBarState extends State<RateBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.defaultSize),
      child: SegmentedButton<LearnFeedback>(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return UIColors.onOverlayCard;
              }
              return UIColors.overlay;
            },
          ),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (Set<MaterialState> states) {
              return UIText.label;
            },
          ),
        ),
        segments: const <ButtonSegment<LearnFeedback>>[
          ButtonSegment<LearnFeedback>(
              value: LearnFeedback.good,
              label: Text('good'),
              icon: Icon(Icons.calendar_view_day)),
          ButtonSegment<LearnFeedback>(
              value: LearnFeedback.medium,
              label: Text('medium'),
              icon: Icon(Icons.calendar_view_week)),
          ButtonSegment<LearnFeedback>(
              value: LearnFeedback.bad,
              label: Text('bad'),
              icon: Icon(Icons.calendar_view_month)),
        ],
        selected: <LearnFeedback>{widget.feedback},
        onSelectionChanged: (Set<LearnFeedback> newSelection) {
          setState(() {
            widget.feedback = newSelection.first;
          });
          context.read<LearnCubit>().rateCard(newSelection.first, widget.index);
        },
      ),
    );
  }
}
