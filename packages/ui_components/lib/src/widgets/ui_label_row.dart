import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// row with a lable text on the left and icons or text on the left
class UILabelRow extends StatelessWidget {
  /// constructor
  const UILabelRow({
    super.key,
    this.horizontalPadding = false,
    this.actionWidgets,
    required this.labelText,
  });

  /// whether the entire row should have horizontalPadding,
  /// when true padding is [UIConstants.cardHorizontalPadding]
  final bool horizontalPadding;

  /// lable text on the beginning of the row, font is [UIText.label]
  final String labelText;

  final List<Widget>? actionWidgets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding ? UIConstants.cardHorizontalPadding : 0,
        right: horizontalPadding ? UIConstants.cardHorizontalPadding : 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TODO add color
          Text(labelText,
              style: UIText.label.copyWith(color: UIColors.smallText)),
          Row(children: actionWidgets ?? [])
        ],
      ),
    );
  }
}
