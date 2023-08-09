import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIPage extends StatelessWidget {
  const UIPage({super.key, this.appBar, this.body});

  final PreferredSizeWidget? appBar;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.pageHorizontalPadding,
          ),
          child: body,
        ),
      ),
    );
  }
}
