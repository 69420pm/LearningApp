import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({super.key, required this.subject});
  final Subject subject;
  @override
  Widget build(BuildContext context) {
    final nextClassTestInDays = SubjectHelper.daysTillNextClassTest(
      subject,
      DateTime.now(),
    );
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
                subject.name,
                style: UIText.titleBig.copyWith(color: UIColors.textDark),
              ),
              const SizedBox(
                height: UIConstants.defaultSize,
              ),
              Text(
                'class test in ${nextClassTestInDays != -1 ? nextClassTestInDays.toString() : "---"} days',
                style: UIText.label.copyWith(
                  color: UIColors.textDark,
                ),
              )
            ],
          ),
          Row(
            children: [
              UIIconButton(
                icon: UIIcons.settings
                    .copyWith(color: UIColors.overlay),
                onPressed: () {
                  Navigator.of(context).pushNamed('/subject_overview/edit_subject', arguments: subject);
                },
                alignment: Alignment.topRight,
                animateToWhite: true,
              ),
              UIIconButton(
                icon: UIIcons.arrowForwardNormal
                    .copyWith(color: UIColors.overlay),
                onPressed: () {},
                alignment: Alignment.topRight,
                animateToWhite: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}
