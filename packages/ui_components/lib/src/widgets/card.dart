// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UICard extends StatelessWidget {
  const UICard({
    Key? key,
    this.onTap,
    this.color,
    this.hight,
    this.width,
    required this.child,
  }) : super(key: key);

  final void Function()? onTap;
  final Color? color;
  final Widget child;
  final double? width;
  final double? hight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width,
          height: hight,
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: child),
    );
  }
}
