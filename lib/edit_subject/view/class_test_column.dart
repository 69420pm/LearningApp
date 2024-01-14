import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';
import 'package:learning_app/edit_subject/view/class_test_list_tile.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/ui_components/widgets/ui_container.dart';
import 'package:learning_app/ui_components/widgets/ui_description.dart';
import 'package:learning_app/ui_components/widgets/ui_label_row.dart';

class ClassTestColumn extends StatelessWidget {
  const ClassTestColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditSubjectCubit, EditSubjectState>(
      buildWhen: (previous, current) => current is EditSubjectClassTestChanged,
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
                      Navigator.of(context)
                          .pushNamed(
                              '/subject_overview/edit_subject/add_class_test',
                              arguments:
                                  context.read<EditSubjectCubit>().subject)
                          .then((value) => context
                              .read<EditSubjectCubit>()
                              .changeClassTests());
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
                    Navigator.of(context)
                        .pushNamed(
                            '/subject_overview/edit_subject/add_class_test',
                            arguments: context.read<EditSubjectCubit>().subject)
                        .then((value) => context
                            .read<EditSubjectCubit>()
                            .changeClassTests());
                  },
                ),
              ],
            ),
            UIContainer(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: classTests.length,
                itemBuilder: (context, index) {
                  return ClassTestListTile(
                    classTest: classTests[index],
                    classTestChanged: () =>
                        context.read<EditSubjectCubit>().changeClassTests(),
                  );
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
