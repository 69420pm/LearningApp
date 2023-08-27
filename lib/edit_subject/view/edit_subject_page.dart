import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/edit_subject/view/class_test_row.dart';
import 'package:learning_app/edit_subject/view/page_weekday_picker.dart';
import 'package:ui_components/ui_components.dart';

import '../cubit/edit_subject_cubit.dart';

class EditSubjectPage extends StatelessWidget {
  EditSubjectPage({super.key, required this.subject});
  final nameController = TextEditingController();
  final Subject subject;
  @override
  Widget build(BuildContext context) {
    nameController.text = subject.name;
    context.read<EditSubjectCubit>().init(subject);
    return UIPage(
      appBar: UIAppBar(
        leading: UIIconButton(
          icon: UIIcons.arrowBack,
          onPressed: () {},
        ),
        actions: [UIIconButton(icon: UIIcons.share, onPressed: () {})],
        title: 'Subject Settings',
      ),
      body: Column(
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
                    context
                        .read<EditSubjectCubit>()
                        .saveSubject(subject.copyWith(name: p0));
                  },
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
            height: UIConstants.itemPadding * 0.75,
          ),
          PageWeekdayPicker(
            subject: subject,
          ),
          const SizedBox(height: UIConstants.descriptionPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.itemPaddingLarge),
            child: Text(
              'Select weekdays on which this subject is scheduled to let the test algorithm adapt to your needs',
              style: UIText.small.copyWith(color: UIColors.smallText),
            ),
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          UILabelRow(
            labelText: 'Exams',
            horizontalPadding: true,
            actionWidgets: [
              UIIconButton(
                  icon: UIIcons.add.copyWith(color: UIColors.smallText),
                  onPressed: () {
                            Navigator.of(context).pushNamed('/subject_overview/edit_subject/add_class_test');

                  },
                  )
            ],
          ),
          ClassTestColumn()
        ],
      ),
    );
  }
}
