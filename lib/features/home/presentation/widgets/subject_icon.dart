import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/progress_indicators/ui_circular_progress_indicator.dart';
import 'package:learning_app/features/file_system/domain/entities/subject.dart';

class SubjectIcon extends StatelessWidget {
  const SubjectIcon({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        UICircularProgressIndicator(
          value: .7,
          color: subject.disabled ? UIColors.primaryDisabled : UIColors.green,
        ),
        UIIcons.debug.copyWith(
          size: 24,
          color: subject.disabled ? UIColors.primaryDisabled : UIColors.green,
        ),
      ],
    );
  }
}
