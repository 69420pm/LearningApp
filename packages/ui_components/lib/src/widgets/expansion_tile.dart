// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:material/material.dart';
import 'package:ui_components/ui_components.dart';

class UIExpansionTile extends StatefulWidget {
  List<Widget> children;
  Text title;
  double titleSpacing;
  double iconSpacing;
  Widget trailing;
  Color backgroundColor;
  Border border;

  UIExpansionTile({
    super.key,
    required this.children,
    required this.title,
    required this.titleSpacing,
    required this.iconSpacing,
    required this.trailing,
    required this.backgroundColor,
    required this.border,
  });

  @override
  State<UIExpansionTile> createState() => _UIExpansionTileState();
}

class _UIExpansionTileState extends State<UIExpansionTile> {
  bool _isOpened = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: update,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(UISizeConstants.cornerRadius)),
          color: widget.backgroundColor,
          border: widget.border,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: widget.iconSpacing),
                Icon(_isOpened ? Icons.expand_less : Icons.expand_more),
                SizedBox(width: widget.titleSpacing),
                widget.title,
                const Spacer(),
                widget.trailing,
              ],
            ),
            if (_isOpened)
              Padding(
                padding:
                    const EdgeInsets.only(right: UISizeConstants.defaultSize),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => widget.children[index],
                  itemCount: widget.children.length,
                ),
              )
          ],
        ),
      ),
    );
  }

  void update() {
    setState(() {
      _isOpened = !_isOpened;
    });
  }
}
