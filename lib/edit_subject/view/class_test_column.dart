import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class ClassTestColumn extends StatelessWidget {
  const ClassTestColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditSubjectCubit, EditSubjectState>(
      builder: (context, state) {
        final classTests = context.read<EditSubjectCubit>().classTests;
        if (classTests.isEmpty) {
          return Column(
            children: [
              UILabelRow(
                labelText: 'Class Tests',
                horizontalPadding: true,
                actionWidgets: [
                  UIIconButton(
                    icon: UIIcons.add.copyWith(color: UIColors.primary),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/subject_overview/edit_subject/add_class_test',
                      );
                    },
                  ),
                ],
              ),
              UIContainer(
                child: UIDescription(
                          text:
                  'Add exams with date to this subject to increase test frequency when approaching an exam, that you are always well prepared for your exams',
                        ),
              ),
            ],
          );
        }
        return Column(
          children: [
             UILabelRow(
            labelText: 'Class Tests',
            horizontalPadding: true,
            actionWidgets: [
              UIIconButton(
                icon: UIIcons.add.copyWith(color: UIColors.smallText),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/subject_overview/edit_subject/add_class_test',
                  );
                },
              ),
              
            ],
          ),
            UIContainer(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: classTests.length,
                itemBuilder: (context, index) {
                  return ClassTestListTile(classTest: classTests[index]);
                },
              ),
            ),
            UIDescription(
            text:
                'Add exams with date to this subject to higher test frequency when approaching an exam, that you are always well prepared for your exams',
            horizontalPadding: true,
          ),
          ],
        );
      },
    );
  }
}

class ClassTestListTile extends StatelessWidget {
  ClassTestListTile({super.key, required this.classTest});
  ClassTest classTest;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pushNamed(
          '/subject_overview/edit_subject/add_class_test',
          arguments: classTest,
        );
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
                  DateFormat('MM/dd/yyyy')
                      .format(classTest.date),
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
