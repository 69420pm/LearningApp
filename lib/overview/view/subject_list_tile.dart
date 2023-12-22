import 'package:flutter/material.dart';
import 'package:learning_app/card_backend/cards_api/helper/subject_helper.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/progress_indicators/ui_circular_progress_indicator.dart';class SubjectListTile extends StatelessWidget {
  const SubjectListTile({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    final nextClassTestInDays = SubjectHelper.daysTillNextClassTest(
      subject,
      DateTime.now(),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context)
          .pushNamed('/subject_overview', arguments: subject),
      child: Padding(
        padding: const EdgeInsets.only(bottom: UIConstants.defaultSize),
        child: Row(
          children: [
            // Icon with progress indicator
            Stack(
              alignment: Alignment.center,
              children: [
                UICircularProgressIndicator(value: 1),
                UIIcons.download.copyWith(size: 24, color: UIColors.primary),
              ],
            ),
            const SizedBox(
              width: UIConstants.itemPaddingLarge,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: UIText.labelBold.copyWith(
                    color: UIColors.textLight,
                  ),
                ),
                if (nextClassTestInDays > -1 && nextClassTestInDays < 15)
                  Column(
                    children: [
                      const SizedBox(height: UIConstants.defaultSize / 2),
                      RichText(
                        text: TextSpan(
                          style:
                              UIText.normal.copyWith(color: UIColors.smallText),
                          children: <TextSpan>[
                            const TextSpan(text: 'class test in '),
                            TextSpan(
                              text: nextClassTestInDays.toString(),
                              style: UIText.normal.copyWith(
                                  color: nextClassTestInDays < 5
                                      ? UIColors.delete
                                      : UIColors.primary),
                            ),
                            TextSpan(
                                text: nextClassTestInDays == 1
                                    ? ' day'
                                    : ' days'),
                          ],
                        ),
                      ),
                    ],
                  ),
                // RichText(
                //   text: TextSpan(
                //     style: UIText.normal.copyWith(color: UIColors.smallText),
                //     children: <TextSpan>[
                //       const TextSpan(text: 'class test in '),
                //       TextSpan(
                //           text: '2 ',
                //           style: UIText.normal.copyWith(color: UIColors.primary)),
                //       const TextSpan(text: 'days'),
                //     ],
                //   ),
                // )
              ],
            ),
            const Spacer(),
            UIIcons.arrowForwardMedium.copyWith(color: UIColors.smallText),
          ],
        ),
      ),
    );
  }
}
