// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class UIGradientText extends StatelessWidget {
  const UIGradientText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [
        Theme.of(context).colorScheme.onTertiaryContainer,
        Theme.of(context).colorScheme.onPrimaryContainer,
      ],
    );
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient
          .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .displayLarge
            ?.copyWith(fontWeight: FontWeight.w900),
      ),
    );
  }
}
