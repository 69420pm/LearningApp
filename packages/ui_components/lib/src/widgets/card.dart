// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UICard extends StatelessWidget {
  const UICard({
    Key? key,
    this.onTap,
    this.color,
    required this.child,
  }) : super(key: key);

  final void Function()? onTap;
  final Color? color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.all(
            Radius.circular(UIConstants.cornerRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.cardHorizontalPadding,
              vertical: UIConstants.cardVerticalPadding),
          child: child,
        ),
      ),
    );
  }
}
