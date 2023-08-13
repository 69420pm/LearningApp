// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
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

  final locationController = TextEditingController();

  final iconController = TextEditingController();

  bool canSave = false;

  @override
  Widget build(BuildContext context) {
    if (widget.recommendedSubjectParentId != null) {
      locationController.text = widget.recommendedSubjectParentId!;
    }
    final weekDayPicker = UIWeekdayPicker();
    return UIBottomSheet(
      actionLeft: UIIconButton(
        icon: UIIcons.close,
        onPressed: () {},
      ),
      title: const Text('Add Subject', style: UIText.label),
      actionRight: UIButton(
        child: Text(
          'Save',
          style: UIText.labelBold.copyWith(
              color: canSave ? UIColors.primary : UIColors.primaryDisabled),
        ),
        onPressed: () {
          print(weekDayPicker.getSelectedDays());
        },
      ),
      child: Column(
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
            height: UIConstants.itemPadding*0.75,
          ),
          weekDayPicker
        ],
      ),
    );
  }

  // void save
}
