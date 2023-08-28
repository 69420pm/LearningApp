// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ui_components/src/widgets/bottom_sheet/ui_bottom_sheet_title_row.dart';
import 'package:ui_components/ui_components.dart';

class UIBottomSheet extends StatelessWidget {
  const UIBottomSheet({
    super.key,
    required this.child,
    this.actionLeft,
    this.title,
    this.actionRight,
  });
  final Widget child;

  /// preferably icon on the left
  final Widget? actionLeft;

  /// preferably text in the center of the row
  final Widget? title;

  /// preferably icon on the right
  final Widget? actionRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: UIConstants.pageHorizontalPadding,
        right: UIConstants.pageHorizontalPadding,
        // bottom is static height, if bottomsheet should move with keyboard
        // use MediaQuery.of(context).viewInsets.bottom,
        // however the animation is a bit leggy and not smooth
        //! not for me. constant height was more leggy and there is no dynamic height possible.

        //bottom: MediaQuery.of(context).size.height * 0.55,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            UIConstants.cardVerticalPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UIBottomSheetTitleRow(
            actionLeft: actionLeft,
            actionRight: actionRight,
            title: title,
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          child
        ],
      ),
    );
  }

  static Future<UIBottomSheet?> showUIBottomSheet({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    final navigator = Navigator.of(context);
    final localizations = MaterialLocalizations.of(context);

    return navigator.push(ModalBottomSheetRoute<UIBottomSheet>(
      builder: builder,
      capturedThemes:
          InheritedTheme.capture(from: context, to: navigator.context),
      isScrollControlled: true,
      barrierLabel: localizations.scrimLabel,
      barrierOnTapHint:
          localizations.scrimOnTapHint(localizations.bottomSheetLabel),
      backgroundColor: UIColors.overlay,
      elevation: 0,
      modalBarrierColor: Theme.of(context).bottomSheetTheme.modalBarrierColor,
      showDragHandle: true,
    ));
  }
}