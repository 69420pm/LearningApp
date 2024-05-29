import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UIExpansionTilee extends StatelessWidget {
  const UIExpansionTilee({
    super.key,
    required this.title,
    required this.children,
    this.onTap,
  });
  final String title;
  final List<Widget> children;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final ExpansionTileController controller = ExpansionTileController();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: ExpansionTile(
        controller: controller,
        title: InkWell(
          onTap: onTap,
          child: Text(title),
        ),
        children: children,
      ),
    );
  }
}
