import 'package:flutter/material.dart' hide SearchBar;
import 'package:learning_app/overview/view/calendar_card.dart';
import 'package:learning_app/overview/view/learn_all_card.dart';
import 'package:learning_app/overview/view/subject_list.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/ui_components/widgets/ui_page.dart';class OverviewPage extends StatelessWidget {
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
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LearnAllCard(),
            SizedBox(height: UIConstants.itemPaddingLarge),
            CalendarCard(),
            SizedBox(height: UIConstants.itemPaddingLarge * 2),
            SubjectList(),
          ],
        ),
      ),
    );
  }
}
