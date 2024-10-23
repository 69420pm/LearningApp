import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';

class UILinearProgressIndicator extends StatelessWidget {
  const UILinearProgressIndicator(
      {super.key, required this.value, this.width = 72, this.height = 5});
  final double value;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: LinearProgressIndicator(
          value: value,
          valueColor: const AlwaysStoppedAnimation<Color>(UIColors.primary),
          backgroundColor: UIColors.overlay,
        ),
      ),
    );
  }
}
