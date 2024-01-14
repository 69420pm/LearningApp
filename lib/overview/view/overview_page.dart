import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/overview/cubit/overview_cubit.dart';
import 'package:learning_app/overview/view/calendar_card.dart';
import 'package:learning_app/overview/view/class_test_tomorrow_card.dart';
import 'package:learning_app/overview/view/learn_all_card.dart';
import 'package:learning_app/overview/view/subject_list.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/ui_components/widgets/ui_page.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    return UIPage(
      appBar: UIAppBar(
        leadingBackButton: false,
        automaticallyImplyLeading: false,
        leading: UIIconButton(
          icon: UIIcons.account,
          onPressed: () {
            Navigator.of(context).pushNamed('/settings');
          },
        ),
        actions: [
          UIIconButton(
            icon: UIIcons.search,
            onPressed: () => Navigator.of(context).pushNamed('/search').then(
                (value) =>
                    context.read<OverviewCubit>().updateLearnAllButton()),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LearnAllCard(),
            SizedBox(height: UIConstants.itemPaddingLarge),
            CalendarCard(),
            SizedBox(height: UIConstants.itemPaddingLarge),
            ClassTestTomorrowCard(),
            SizedBox(height: UIConstants.itemPaddingLarge),
            SubjectList(),
          ],
        ),
      ),
    );
  }
}
