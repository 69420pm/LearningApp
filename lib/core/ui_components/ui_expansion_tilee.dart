import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UIExpansionTilee extends StatelessWidget {
  const UIExpansionTilee(
      {super.key,
      required this.title,
      required this.children,
      this.onTap,
      this.controller});
  final String title;
  final List<Widget> children;
  final void Function()? onTap;
  final ExpansionTileController? controller;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      controller: controller,
      title: InkWell(
        onTap: onTap,
        child: Text(title),
      ),
      children: children,
    );
  }
}
