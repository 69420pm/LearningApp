import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/add_subject/view/add_subject_bottom_sheet.dart';
import 'package:learning_app/overview/bloc/overview_bloc.dart';
import 'package:learning_app/overview/view/learn_all_button.dart';
import 'package:learning_app/overview/view/search_bar.dart';
import 'package:learning_app/overview/view/subject_list.dart';
import 'package:learning_app/overview/view/subject_list_tile.dart';
import 'package:ui_components/ui_components.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UIPage(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: UIConstants.itemPadding),
          const LearnAllButton(),
          const SizedBox(height: UIConstants.itemPadding * 2),
          UILabelRow(
            labelText: 'Subjects',
            actionWidgets: [
              UIIconButton(
                icon: UIIcons.download.copyWith(color: UIColors.smallText),
                onPressed: () {},
              ),
              UIIconButton(
                icon: UIIcons.add.copyWith(color: UIColors.smallText),
                onPressed: () => showModalBottomSheet(
                  elevation: 0,
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<AddSubjectCubit>(),
                    child: AddSubjectBottomSheet(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.itemPadding),
          SubjectList(),
          const SizedBox(height: UIConstants.itemPadding * 2),
          UILabelRow(
            labelText: "Disabled",
            actionWidgets: [
              UIIcons.arrowDown.copyWith(color: UIColors.smallText)
            ],
          )
        ],
      ),
    );
  }
}
