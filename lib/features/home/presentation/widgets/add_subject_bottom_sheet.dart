// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button_large.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/text_fields/ui_text_field_large.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_description.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_label_row.dart';
import 'package:learning_app/features/home/presentation/bloc/home_bloc.dart';

class AddSubjectBottomSheet extends StatefulWidget {
  const AddSubjectBottomSheet({
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
                .read<HomeBloc>()
                .add(HomeSubjectAddSubject(name: nameController.text));
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
            height: UIConstants.itemPaddingSmall,
          ),
          // const WeekdayPicker(),
          const Placeholder(fallbackHeight: 100),
          UIDescription(
            text:
                'Select weekdays on which this subject is scheduled to let the test algorithm adapt to your needs ',
          ),
        ],
      ),
    );
  }

  // void save
}
