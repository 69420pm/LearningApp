import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';
import 'package:ui_components/ui_components.dart';

class SubjectCard extends StatelessWidget {
  SubjectCard({super.key, required this.subject});
  Subject subject;
  @override
  Widget build(BuildContext context) {
    return UICard(
      useGradient: true,
      distanceToTop: 80,
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<EditSubjectCubit, EditSubjectState>(
            buildWhen: (previous, current) => current is EditSubjectSuccess,
            builder: (context, state) {
              if (state is EditSubjectSuccess) {
                subject = state.subject;
              }
              final nextClassTestInDays = SubjectHelper.daysTillNextClassTest(
                subject,
                DateTime.now(),
              );
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    style: UIText.titleBig.copyWith(color: UIColors.textDark),
                  ),
                  const SizedBox(
                    height: UIConstants.itemPadding / 2,
                  ),
                  Text(
                    'class test in ${nextClassTestInDays != -1 ? nextClassTestInDays.toString() : "---"} days',
                    style: UIText.label.copyWith(
                      color: UIColors.textDark,
                    ),
                  ),
                  if (subject.disabled)
                    Column(
                      children: [
                        const SizedBox(height: UIConstants.itemPadding),
                        Row(
                          children: [
                            UIIcons.info.copyWith(color: UIColors.textDark),
                            const SizedBox(width: UIConstants.descriptionPadding,),
                            Text('This subject is disabled, enable in Settings', style: UIText.smallBold.copyWith(color: UIColors.textDark)),
                          ],
                        ),
                      ],
                    ),
                  
                ],
              );
            },
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Row(
              children: [
                
                UIIconButton(
                  icon: UIIcons.arrowForwardNormal
                      .copyWith(color: UIColors.overlay),
                  onPressed: () {},
                  alignment: Alignment.topRight,
                  animateToWhite: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
