import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class SubjectListTile extends StatelessWidget {
  const SubjectListTile({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed('/subject_overview', arguments: subject),
      child: Row(
        children: [
          // Icon with progress indicator
          Stack(
            alignment: Alignment.center,
            children: [
              UICircularProgressIndicator(value: 0.5),
              UIIcons.download.copyWith(size: 24, color: UIColors.primary)
            ],
          ),
          const SizedBox(
            width: UIConstants.itemPadding*1.5,
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
              const SizedBox(height: UIConstants.defaultSize / 2),
              RichText(
                text: TextSpan(
                  style: UIText.normal.copyWith(color: UIColors.smallText),
                  children: <TextSpan>[
                    const TextSpan(text: 'class test in '),
                    TextSpan(
                        text: '2 ',
                        style: UIText.normal.copyWith(color: UIColors.primary)),
                    const TextSpan(text: 'days'),
                  ],
                ),
              )
            ],
          ),
          const Spacer(),
          UIIcons.arrowForwardMedium.copyWith(color: UIColors.smallText),
        ],
      ),
    );
  }
}
