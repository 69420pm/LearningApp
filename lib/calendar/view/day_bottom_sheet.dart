import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/edit_subject/view/class_test_list_tile.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/ui_components/widgets/ui_description.dart';
import 'package:learning_app/ui_components/widgets/ui_label_row.dart';

class DayBottomSheet extends StatelessWidget {
  const DayBottomSheet({
    super.key,
    required this.dateTime,
    required this.classTests,
  });
  final DateTime dateTime;
  final List<ClassTest>? classTests;
  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      title: Text(
        '${DateFormat.E().format(dateTime)} ${DateFormat.MMM().format(dateTime)} ${DateFormat.d().format(dateTime)} ${DateFormat.y().format(dateTime)}',
        style: UIText.label,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UILabelRow(
            labelText: 'Exams',
          ),
          const SizedBox(height: UIConstants.itemPadding),
          Builder(
            builder: (context) {
              if (classTests == null || classTests!.isEmpty) {
                return Text(
                  'no exams on this day',
                  style: UIText.normal.copyWith(color: UIColors.smallText),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: classTests!.length,
                  itemBuilder: (context, index) {
                    return ClassTestListTile(classTest: classTests![index]);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
