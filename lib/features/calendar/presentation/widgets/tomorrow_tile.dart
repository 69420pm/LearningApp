import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button_large.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/file_system/domain/entities/subject.dart';
import 'package:learning_app/features/home/presentation/widgets/subject_icon.dart';
import 'package:learning_app/generated/l10n.dart';

class TomorrowTile extends StatelessWidget {
  const TomorrowTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //get from database
    var subjectsTomorrow = List.generate(
      3,
      (index) => Subject(
        id: index.toString(),
        name: "$index",
        dateCreated: DateTime.now(),
        lastChanged: DateTime.now(),
        icon: index,
        streakRelevant: true,
        disabled: false,
      ),
    );

    return UICard(
      useGradient: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tomorrow",
                  style: UIText.titleBig.copyWith(color: UIColors.textLight),
                  overflow: TextOverflow.fade,
                ),
                const SizedBox(height: UIConstants.defaultSize),
                Row(
                  children: [
                    ...subjectsTomorrow.map(
                      (subject) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: UIConstants.defaultSize,
                          ),
                          child: Column(
                            children: [
                              SubjectIcon(subject: subject),
                              Text(subject.name,
                                  style: UIText.label.copyWith(
                                    color: subject.disabled
                                        ? UIColors.smallText
                                        : UIColors.textLight,
                                  )),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          UIIcons.arrowForwardNormal,
        ],
      ),
    );
  }
}
