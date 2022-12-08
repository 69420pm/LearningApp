// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class UIExpansionTile extends StatefulWidget {
  List<Widget> children;
  String title;
  UIExpansionTile({
    super.key,
    required this.children,
    required this.title,
  });

  @override
  State<UIExpansionTile> createState() => _UIExpansionTileState();
}

class _UIExpansionTileState extends State<UIExpansionTile> {
  bool _isOpened = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon:
                  _isOpened ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () => update(),
            ),
            Text(widget.title),
          ],
        ),
        if (_isOpened) ...widget.children
      ],
    );
  }

  void update() {
    setState(() {
      _isOpened = !_isOpened;
    });
  }
}
