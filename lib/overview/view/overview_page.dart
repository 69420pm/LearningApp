import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/add_subject/view/add_subject_bottom_sheet.dart';
import 'package:learning_app/overview/view/calendar_card.dart';
import 'package:learning_app/overview/view/learn_all_card.dart';
import 'package:learning_app/overview/view/subject_list.dart';
import 'package:ui_components/ui_components.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UIPage(
      appBar: UIAppBar(
        leading: UIIconButton(
          icon: UIIcons.account,
          onPressed: () {},
        ),
        actions: [
          UIIconButton(
            icon: UIIcons.search,
            onPressed: () => Navigator.of(context).pushNamed('/search'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LearnAllCard(),
            const SizedBox(height: UIConstants.itemPaddingLarge),
            const CalendarCard(),
            const SizedBox(height: UIConstants.itemPaddingLarge * 2),
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
            const SizedBox(
              height: UIConstants.itemPaddingLarge,
            ),
            SubjectList(),
            const SizedBox(height: UIConstants.itemPaddingLarge * 2),
            UILabelRow(
              labelText: 'Disabled',
              actionWidgets: [
                UIIcons.arrowDown.copyWith(color: UIColors.smallText),
              ],
            ),
            const SizedBox(
              height: UIConstants.itemPaddingLarge,
            ),
            // SubjectList(
            //   showDisabled: true,
            // ),
          ],
        ),
      ),
    );
  }
}
