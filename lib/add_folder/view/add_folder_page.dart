import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button_large.dart';
import 'package:learning_app/ui_components/widgets/text_fields/ui_text_field_large.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/ui_components/widgets/ui_label_row.dart';
import 'package:learning_app/ui_components/widgets/ui_page.dart';class AddFolderPage extends StatelessWidget {
  const AddFolderPage({super.key});

  @override
  Widget build(BuildContext context) {
  final nameController = TextEditingController();

    return UIPage(
      appBar: UIAppBar(
        leading: UIIconButton(
          icon: UIIcons.arrowBack,
          onPressed: () {},
        ),
        actions: [
        UIIconButton(
          icon: UIIcons.share,
          onPressed: () {},
        ),
      ],),
      body: Column(
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
                      // setState(() {
                      //   canSave = false;
                      // });
                    } else {
                      // setState(() {
                      //   canSave = true;
                      // });
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
          // WeekdayPicker(),
          const SizedBox(height: UIConstants.descriptionPadding),
          Text(
            'Select weekdays on which this subject is scheduled to let the test algorithm adapt to your needs',
            style: UIText.small.copyWith(color: UIColors.smallText),
          ),
        ],
      ),
    );
  }
}
