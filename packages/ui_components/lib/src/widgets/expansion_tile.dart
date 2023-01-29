// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:material/material.dart';

class UIExpansionTile extends StatefulWidget {
  List<Widget> children;
  String title;
  void Function() onPressedCallback;
  void Function()? testCallback;

  UIExpansionTile(
      {super.key,
      required this.children,
      required this.title,
      required this.onPressedCallback,
      this.testCallback,});

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
              icon: Icon(_isOpened ? Icons.expand_less : Icons.expand_more),
              onPressed: update,
            ),
            Text(widget.title),
            // IconButton(
            //   icon: const Icon(Icons.flutter_dash),
            //   onPressed: () {
            //     widget.testCallback?.call();
            //   },
            // ),
            IconButton(
                icon: const Icon(MaterialIcons.delete_circle_outline),
                onPressed: widget.onPressedCallback,)
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
