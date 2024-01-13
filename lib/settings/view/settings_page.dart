import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/ui_components/widgets/ui_card.dart';
import 'package:learning_app/ui_components/widgets/ui_label_row.dart';
import 'package:learning_app/ui_components/widgets/ui_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UIPage(
      appBar: UIAppBar(
        title: 'Settings',
        actions: [UIIconButton(icon: UIIcons.search, onPressed: () {})],
      ),
      body: Column(
        children: [
          const UILabelRow(
            labelText: 'Account',
            horizontalPadding: true,
          ),
          const SizedBox(height: UIConstants.itemPadding),
          UICard(
            useGradient: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your account name',
                        style: UIText.titleSmall
                            .copyWith(color: UIColors.textDark)),
                    Text('Your email address',
                        style:
                            UIText.normal.copyWith(color: UIColors.textDark)),
                  ],
                ),
                UIIconButton(
                  icon: UIIcons.arrowForwardNormal
                      .copyWith(color: UIColors.textDark),
                  onPressed: () {},
                )
              ],
            ),
          ),
          const SizedBox(height: UIConstants.itemPaddingLarge),
          const UILabelRow(
            labelText: 'General',
            horizontalPadding: true,
          ),
        ],
      ),
    );
  }
}
