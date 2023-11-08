import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/add_subject/view/add_subject_bottom_sheet.dart';
import 'package:learning_app/overview/cubit/overview_cubit.dart';
import 'package:learning_app/overview/view/subject_list_tile.dart';
import 'package:ui_components/ui_components.dart';

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
        return Column(children: [
          UILabelRow(
            labelText: 'Subjects',
            actionWidgets: [
              UIIconButton(
                icon: UIIcons.download.copyWith(color: UIColors.smallText),
                onPressed: () {},
              ),
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
          const SizedBox(height: UIConstants.itemPadding * 2),
          UIExpansionTile(
              title: "Disabled Subjects",
              textColor: UIColors.smallText,
              childSpacing: UIConstants.itemPadding,
              children: subjects
                  .where((element) => element.subject.disabled)
                  .toList()),
        ]);
      },
    );
  }
}
