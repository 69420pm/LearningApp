import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuillToggleButton extends StatefulWidget {
  QuillToggleButton(
      {super.key,
      required this.onSelect,
      required this.onUnselect,
      required this.onBuild,
      required this.icon,
      required this.controller});
  Function() onSelect;
  Function() onUnselect;
  bool Function() onBuild;
  IconData icon;
  QuillController controller;
  @override
  State<QuillToggleButton> createState() => _QuillToggleButtonState();
}

class _QuillToggleButtonState extends State<QuillToggleButton> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeEditUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_didChangeEditUpdate);
  }

  @override
  Widget build(BuildContext context) {
    isSelected = widget.onBuild();
    return IconButton(
      icon: Icon(widget.icon),
      style: ButtonStyle(
        backgroundColor: isSelected
            ? WidgetStatePropertyAll(Colors.green)
            : WidgetStatePropertyAll(Colors.grey),
      ),
      onPressed: () {
        if (!isSelected) {
          widget.onSelect();
        } else {
          widget.onUnselect();
        }
      },
    );
  }

  void _didChangeEditUpdate() {
    setState(() {
      isSelected;
    });
  }
}
