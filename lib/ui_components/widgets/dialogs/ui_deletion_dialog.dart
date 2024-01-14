import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_button.dart';

class UIDeletionDialog extends StatelessWidget {
  UIDeletionDialog(
      {super.key, required this.whatToDelete, required this.onAccepted,});

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
          child: const Text('Cancel', style: UIText.label),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        UIButton(
          onPressed: onAccepted,
          child: Text('Delete',
              style: UIText.labelBold.copyWith(color: UIColors.delete),),
        ),
       
      ],
    );
  }
}
