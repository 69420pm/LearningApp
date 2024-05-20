import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';

/// row with a lable text on the left and icons or text on the left
class UILabelRow extends StatelessWidget {
  /// constructor
  const UILabelRow({
    super.key,
    this.horizontalPadding = false,
    this.actionWidgets,
    this.labelText,
  });

  /// whether the entire row should have horizontalPadding,
  /// when true padding is [UIConstants.cardHorizontalPadding]
  final bool horizontalPadding;

  /// label text on the beginning of the row, font is [UIText.label]
  final String? labelText;

  final List<Widget>? actionWidgets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ? UIConstants.cardHorizontalPadding : 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (labelText != null)
            Text(
              labelText!,
              style: UIText.label.copyWith(color: UIColors.smallText),
            ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actionWidgets ?? [],
            ),
          ),
        ],
      ),
    );
  }
}
