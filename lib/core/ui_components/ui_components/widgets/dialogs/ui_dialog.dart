import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';

class UIDialog extends StatelessWidget {
  UIDialog({
    super.key,
    required this.title,
    required this.body,
    required this.actions,
  });

  String title;
  String body;
  List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: UIText.labelBold,
      ),
      content: Text(
        body,
        style: UIText.normal,
      ),
      backgroundColor: UIColors.overlay,
      elevation: 0,
      actions: actions,
    );
  }
}
