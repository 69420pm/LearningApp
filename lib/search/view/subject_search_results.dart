import 'package:flutter/material.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/overview/view/subject_list_tile.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/ui_label_row.dart';

class SubjectsSearchResults extends StatelessWidget {
  SubjectsSearchResults({super.key, required this.foundSubjects}) {
    if (foundSubjects.isNotEmpty) {
      var i = 0;
      for (final element in foundSubjects) {
        subjectTiles.add(SubjectListTile(subject: element));
        if (i < foundSubjects.length - 1) {
          subjectTiles.add(
            const SizedBox(
              height: UIConstants.itemPadding * 1.5,
            ),
          );
        } else {
          subjectTiles.add(
            const SizedBox(
              height: UIConstants.itemPadding * 0.5,
            ),
          );
        }
        i++;
      }
    }
  }
  List<Subject> foundSubjects;
  List<Widget> subjectTiles = [
    const SizedBox(
      height: UIConstants.itemPadding * 0.5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (foundSubjects.isNotEmpty) {
      return Column(
        children: [
          UILabelRow(
            labelText: 'Subjects',
            actionWidgets: [
              Text(
                '${foundSubjects.length} Found',
                style: UIText.label.copyWith(color: UIColors.smallText),
              ),
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          Column(
            children: subjectTiles,
          ),
          const SizedBox(height: UIConstants.itemPaddingLarge * 2),
        ],
      );
    } else {
      return Container(height: 0);
    }
  }
}
