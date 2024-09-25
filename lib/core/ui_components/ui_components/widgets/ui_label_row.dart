import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';

/// row with a lable text on the left and icons or text on the left
class UILabelRow extends StatelessWidget {
  /// constructor
  const UILabelRow(
      {super.key,
      this.horizontalPadding = false,
      this.actionWidgets,
      this.labelText,
      this.color});

  /// whether the entire row should have horizontalPadding,
  /// when true padding is [UIConstants.cardHorizontalPadding]
  final bool horizontalPadding;

  /// label text on the beginning of the row, font is [UIText.label]
  final String? labelText;
  final Color? color;

  final List<Widget>? actionWidgets;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
      ),
      alignment: Alignment.center,
      child: Padding(
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
      ),
    );
  }
}

class StickyToolBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  StickyToolBarHeaderDelegate(this.child);
  final Widget child;

  @override
  double get minExtent => UIConstants.defaultSize * 6;

  @override
  double get maxExtent => UIConstants.defaultSize * 6;

  @override
  Widget build(BuildContext context, double __, bool _) => child;

  @override
  bool shouldRebuild(covariant StickyToolBarHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
