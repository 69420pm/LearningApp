import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class InactiveListTile extends StatelessWidget {
  const InactiveListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.defaultSize),
      child: Container(
        width: double.infinity,
        height: UIConstants.defaultSize * 5,
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),
          color: UIColors.overlayDisabled,
        ),
      ),
    );
  }
}
