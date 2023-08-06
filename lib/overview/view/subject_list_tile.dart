import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
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
          //Icon with progressindicator
          // TODO implement progressindicator
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                    color: UIColors.primary,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                    color: UIColors.background,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
              UIIcons.download
            ],
          ),
          SizedBox(
            width: UIConstants.itemPadding,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject.name,
                style: UIText.normalBold.copyWith(
                  color: UIColors.textLight,
                ),
              ),
              const SizedBox(height: UIConstants.defaultSize / 2),
              RichText(
                text: TextSpan(
                  style: UIText.normal.copyWith(color: UIColors.smallText),
                  children: <TextSpan>[
                    TextSpan(text: "classtest in "),
                    TextSpan(
                        text: "2 ",
                        style: UIText.normal.copyWith(color: UIColors.primary)),
                    TextSpan(text: "days"),
                  ],
                ),
              )
            ],
          ),
          const Spacer(),
          UIIcons.arrowForward.copyWith(color: UIColors.smallText),
        ],
      ),
    );
  }
}
