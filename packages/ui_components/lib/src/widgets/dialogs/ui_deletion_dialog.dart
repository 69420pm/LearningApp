import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIDeletionDialog extends StatelessWidget {
  UIDeletionDialog(
      {super.key, required this.whatToDelete, required this.onAccepted});

  String whatToDelete;
  void Function() onAccepted;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete $whatToDelete?',
        style: UIText.labelBold,
      ),
      content: Text(
        'This ${whatToDelete.toLowerCase()} will be deleted. This action cannot be undone.',
        style: UIText.normal,
      ),
      backgroundColor: UIColors.overlay,
      elevation: 0,
      actions: [
         UIButton(
          child: Text('Cancel', style: UIText.label),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        UIButton(
          child: Text('Delete',
              style: UIText.labelBold.copyWith(color: UIColors.delete)),
          onPressed: onAccepted,
        ),
       
      ],
    );
  }
}
