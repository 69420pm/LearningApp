// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/bottom_sheet/ui_bottom_sheet_title_row.dart';

class UIBottomSheet extends StatelessWidget {
  const UIBottomSheet({
    super.key,
    required this.child,
    this.actionLeft,
    this.title,
    this.actionRight,
    this.addPadding = true,
  });
  final Widget child;

  /// preferably icon on the left
  final Widget? actionLeft;

  /// preferably text in the center of the row
  final Widget? title;

  /// preferably icon on the right
  final Widget? actionRight;

  /// whether a standard horizontal padding should get applied
  final bool addPadding;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).viewInsets.bottom +
        (addPadding ? UIConstants.cardVerticalPadding : 0.0);
    return Padding(
      padding: EdgeInsets.only(
        left: addPadding ? UIConstants.pageHorizontalPadding : 0,
        right: addPadding ? UIConstants.pageHorizontalPadding : 0,
        // bottom is static height, if bottomsheet should move with keyboard
        // use MediaQuery.of(context).viewInsets.bottom,
        // however the animation is a bit leggy and not smooth
        //! not for me. constant height was more leggy and there is no dynamic height possible.

        //bottom: MediaQuery.of(context).size.height * 0.55,
        bottom: height,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: addPadding ? 0 : UIConstants.pageHorizontalPadding),
            child: UIBottomSheetTitleRow(
              actionLeft: actionLeft,
              actionRight: actionRight,
              title: title,
            ),
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          child,
        ],
      ),
    );
  }

  static Future<UIBottomSheet?> showUIBottomSheet({
    required BuildContext context,
    required WidgetBuilder builder,
    bool transparentBarrier = false,
  }) {
    final navigator = Navigator.of(context);
    final localizations = MaterialLocalizations.of(context);

    return navigator.push(
      ModalBottomSheetRoute<UIBottomSheet>(
        builder: builder,
        capturedThemes:
            InheritedTheme.capture(from: context, to: navigator.context),
        isScrollControlled: true,
        barrierLabel: localizations.scrimLabel,
        barrierOnTapHint:
            localizations.scrimOnTapHint(localizations.bottomSheetLabel),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        elevation: 0,
        modalBarrierColor: transparentBarrier
            ? Colors.transparent
            : Theme.of(context).bottomSheetTheme.modalBarrierColor,
        showDragHandle: true,
      ),
    );
  }
}
