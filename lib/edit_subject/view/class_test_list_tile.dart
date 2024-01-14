import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';

class ClassTestListTile extends StatelessWidget {
  ClassTestListTile(
      {super.key,
      required this.classTest,
      this.subject,
      this.classTestChanged});
  ClassTest classTest;

  /// give subject when cubit doesn't know about parent subject of classTest
  Subject? subject;
  void Function()? classTestChanged;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (subject != null) {
          Navigator.of(context).pushNamed(
            '/subject_overview/edit_subject/edit_class_test',
            arguments: [classTest, subject],
          ).then((value) {
            if (classTestChanged != null) {
              classTestChanged!.call();
            }
          });
        } else {
          subject = context.read<EditSubjectCubit>().subject;
          Navigator.of(context).pushNamed(
            '/subject_overview/edit_subject/edit_class_test',
            arguments: [classTest, subject],
          ).then((value) {
            if (classTestChanged != null) {
              classTestChanged!.call();
            }
          });
        }

        // context.read<EditSubjectCubit>().init(subject);
      },
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.itemPadding / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                UIIcons.classTest.copyWith(size: UIConstants.iconSizeSmall),
                const SizedBox(
                  width: UIConstants.itemPadding / 1.6,
                ),
                Text(classTest.name, style: UIText.label),
              ],
            ),
            Row(
              children: [
                Text(
                  DateFormat('MM/dd/yyyy').format(classTest.date),
                  style: UIText.label,
                ),
                const SizedBox(
                  width: UIConstants.itemPadding * 0.5,
                ),
                UIIcons.arrowForwardSmall.copyWith(color: UIColors.smallText),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
