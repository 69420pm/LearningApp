import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/add_subject/view/add_subject_bottom_sheet.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/editor/widgets/editor_tiles/divider_tile.dart';
import 'package:learning_app/overview/cubit/overview_cubit.dart';
import 'package:learning_app/overview/view/subject_list_tile.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/ui_components/widgets/ui_expansion_tile.dart';
import 'package:learning_app/ui_components/widgets/ui_label_row.dart';

class SubjectList extends StatelessWidget {
  const SubjectList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          context.read<OverviewCubit>().cardsRepository.getSubjects(),
      builder: (context, box, _) {
        final subjects = box.values
            .toList()
            .cast<Subject>()
            .map((e) => SubjectListTile(subject: e))
            .toList();
        return Column(
          children: [
            UILabelRow(
              labelText: 'Subjects',
              actionWidgets: [
                // UIIconButton(
                //   icon: UIIcons.download.copyWith(color: UIColors.smallText),
                //   onPressed: () {},
                // ),
                UIIconButton(
                  icon: UIIcons.add.copyWith(color: UIColors.smallText),
                  onPressed: () {
                    context.read<AddSubjectCubit>().resetWeekDays();
                    UIBottomSheet.showUIBottomSheet(
                      context: context,
                      builder: (_) {
                        return BlocProvider.value(
                          value: context.read<AddSubjectCubit>(),
                          child: const AddSubjectBottomSheet(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: UIConstants.itemPadding),
            ...subjects.where((element) => element.subject.disabled == false),
            ...subjects.where((element) => element.subject.disabled == true),
          ],
        );
      },
    );
  }
}
