import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/edit_subject/view/class_test_column.dart';
import 'package:learning_app/edit_subject/view/page_weekday_picker.dart';
import 'package:ui_components/ui_components.dart';

import '../cubit/edit_subject_cubit.dart';

class EditSubjectPage extends StatelessWidget {
  EditSubjectPage({super.key, required this.subject});
  final nameController = TextEditingController();
  Subject subject;
  @override
  Widget build(BuildContext context) {
    nameController.text = subject.name;
    context.read<EditSubjectCubit>().init(subject);

    return UIPage(
      dismissFocusOnTap: true,
      appBar: UIAppBar(
        leadingBackButton: true,
        actions: [UIIconButton(icon: UIIcons.share, onPressed: () {})],
        title: 'Subject Settings',
      ),
      body: ListView(
        children: [
          Row(
            children: [
              UIIconButtonLarge(
                onBottomSheet: false,
                icon: UIIcons.placeHolder.copyWith(color: UIColors.primary),
                onPressed: () {},
              ),
              const SizedBox(
                width: UIConstants.itemPadding * 0.75,
              ),
              Expanded(
                child: UITextFieldLarge(
                  controller: nameController,
                  onChanged: (p0) {
                    subject = subject.copyWith(name: p0);
                    context.read<EditSubjectCubit>().saveSubject(subject);
                  },
                  onFieldSubmitted: (_){},
                ),
              ),
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          const UILabelRow(
            labelText: 'Schedule',
            horizontalPadding: true,
          ),
          const SizedBox(
            height: UIConstants.itemPaddingSmall,
          ),
          PageWeekdayPicker(
            subject: subject,
          ),
          UIDescription(
            text:
                'Select weekdays on which this subject is scheduled to let the test algorithm adapt to your needs',
            horizontalPadding: true,
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          const ClassTestColumn(),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          const UILabelRow(
            labelText: 'General',
            horizontalPadding: true,
          ),
          const SizedBox(
            height: UIConstants.itemPaddingSmall,
          ),
          UIContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.cardHorizontalPadding,
              vertical: UIConstants.cardVerticalPadding - 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Streak Relevant', style: UIText.label),
                UISwitch(
                  startValue: subject.streakRelevant,
                  onChanged: null //(value) {
                  //   subject = subject.copyWith(streakRelevant: value);
                  //   context.read<EditSubjectCubit>().saveSubject(subject);
                  // },
                ),
              ],
            ),
          ),
          UIDescription(
              horizontalPadding: true,
              text:
                  "If disabled subject doesn't get considered for streaks and notifications"),
          const SizedBox(
            height: UIConstants.itemPadding,
          ),
          UIContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.cardHorizontalPadding,
              vertical: UIConstants.cardVerticalPadding - 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Disable Subject', style: UIText.label),
                UISwitch(
                  startValue: subject.disabled,
                  
                  onChanged: (value) {
                    subject = subject.copyWith(disabled: value);
                    context.read<EditSubjectCubit>().saveSubject(subject);
                  },
                ),
              ],
            ),
          ),
          UIDescription(
              horizontalPadding: true,
              text:
                  "If disabled, subject doesn't get considered for streaks and doesn't get displayed normally on start page, it is now displayed under the 'disabled' category"),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          UIDeletionRow(
              deletionText: "Delete Subject",
              onPressed: () {
                context.read<EditSubjectCubit>().deleteSubject(subject.id);
              })
        ],
      ),
    );
  }
}
