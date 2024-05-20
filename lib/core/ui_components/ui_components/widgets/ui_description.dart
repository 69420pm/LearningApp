import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';

class UIDescription extends StatelessWidget {
  UIDescription({
    super.key,
    required this.text,
    this.horizontalPadding = false,
  });

  /// description text
  String text;

  /// whether the text should've a horizontal padding
  /// of [UIConstants.cardHorizontalPadding]
  bool horizontalPadding;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: UIConstants.descriptionPadding,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                horizontalPadding ? UIConstants.cardHorizontalPadding : 0,
          ),
          child: Text(
            text,
            style: UIText.small.copyWith(color: UIColors.smallText),
          ),
        ),
      ],
    );
  }
}
