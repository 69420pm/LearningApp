import 'package:flutter/material.dart';

import '../ui_constants.dart';

class UIPage extends StatelessWidget {
  const UIPage({
    super.key,
    this.appBar,
    this.body,
    this.dismissFocusOnTap = false,
    this.addPadding = true,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final bool addPadding;

  /// when press anywhere on the screen dismiss focus,
  /// used most of the time to dismiss keyboard, when clicked outside keyboard
  /// https://www.google.com/search?q=flutter+textfield+dismiss+keyboard&oq=flutter+textfield+hide+ke&aqs=chrome.2.0i19i512j69i57j0i19i22i30l2j69i60.14853j0j7&sourceid=chrome&ie=UTF-8#kpvalbx=_IfztZN6ODIuLxc8PlKqWoAo_26
  final bool dismissFocusOnTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (dismissFocusOnTap) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        appBar: appBar,
        body: SafeArea(
          child: Padding(
            padding: addPadding
                ? const EdgeInsets.only(
                    left: UIConstants.pageHorizontalPadding,
                    right: UIConstants.pageHorizontalPadding,
                    top: UIConstants.pageVerticalPadding,
                  )
                : const EdgeInsets.all(0),
            child: body,
          ),
        ),
      ),
    );
  }
}
