import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';

class InactiveListTile extends StatelessWidget {
  const InactiveListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.defaultSize),
      child: Container(
        width: double.infinity,
        height: UIConstants.defaultSize * 8,
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
    );
  }
}
