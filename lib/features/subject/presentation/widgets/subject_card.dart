import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/file_system/domain/entities/subject.dart';

class SubjectCard extends StatelessWidget {
  SubjectCard({super.key, required this.subjectId});
  String subjectId;
  @override
  Widget build(BuildContext context) {
    final nextClassTestInDays = 69;
    return UICard(
      useGradient: true,
      distanceToTop: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "learn this",
                style: UIText.titleBig.copyWith(color: UIColors.textDark),
              ),
              if (nextClassTestInDays != -1)
                const SizedBox(
                  height: UIConstants.itemPadding / 2,
                ),
              if (nextClassTestInDays != -1)
                Text(
                  'class test in ${nextClassTestInDays.toString()} days',
                  style: UIText.label.copyWith(
                    color: UIColors.textDark,
                  ),
                ),
              // if (subject.disabled)
              //   Column(
              //     children: [
              //       const SizedBox(height: UIConstants.itemPadding),
              //       Row(
              //         children: [
              //           UIIcons.info.copyWith(color: UIColors.textDark),
              //           const SizedBox(
              //             width: UIConstants.descriptionPadding,
              //           ),
              //           Text('This subject is disabled, enable in Settings',
              //               style: UIText.smallBold
              //                   .copyWith(color: UIColors.textDark)),
              //         ],
              //       ),
              //     ],
              //   ),
            ],
          ),
          Row(
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
        ],
      ),
    );
  }
}
