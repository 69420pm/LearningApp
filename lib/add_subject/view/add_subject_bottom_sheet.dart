// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/add_subject/view/weekday_picker.dart';
import 'package:ui_components/ui_components.dart';

class AddSubjectBottomSheet extends StatefulWidget {
  AddSubjectBottomSheet({
    super.key,
    this.recommendedSubjectParentId,
  });

  final String? recommendedSubjectParentId;

  @override
  State<AddSubjectBottomSheet> createState() => _AddSubjectBottomSheetState();
}

class _AddSubjectBottomSheetState extends State<AddSubjectBottomSheet> {
  final nameController = TextEditingController();
  final iconController = TextEditingController();

  bool canSave = false;

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      actionLeft: UIIconButton(
        icon: UIIcons.close,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text('Add Subject', style: UIText.label),
      actionRight: UIButton(
        child: Text(
          'Save',
          style: UIText.labelBold.copyWith(
            color: canSave ? UIColors.primary : UIColors.primaryDisabled,
          ),
        ),
        onPressed: () {
          if (canSave) {
            context
                .read<AddSubjectCubit>()
                .saveSubject(nameController.text, 'TODO', context.read<AddSubjectCubit>().selectedDays);
            Navigator.pop(context);
          }
        },
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              UIIconButtonLarge(
                icon: UIIcons.placeHolder.copyWith(color: UIColors.primary),
                onPressed: () {},
              ),
              const SizedBox(
                width: UIConstants.itemPadding * 0.75,
              ),
              Expanded(
                child: UITextFieldLarge(
                  controller: nameController,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subject name';
                    }
                    return null;
                  },
                  onChanged: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      setState(() {
                        canSave = false;
                      });
                    } else {
                      setState(() {
                        canSave = true;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          const UILabelRow(labelText: 'Schedule'),
          const SizedBox(
            height: UIConstants.itemPadding * 0.75,
          ),
          WeekdayPicker(),
          const SizedBox(height: UIConstants.descriptionPadding),
          Text(
            'Select weekdays on which this subject is scheduled to let the test algorithm adapt to your needs',
            style: UIText.small.copyWith(color: UIColors.smallText),
          )
        ],
      ),
    );
  }

  // void save
}
