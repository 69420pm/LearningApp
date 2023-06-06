import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIAppBar extends AppBar {
  UIAppBar({super.key, super.title, super.scrolledUnderElevation});

  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(UIConstants.defaultSize * 4),
      child: this,
    );
  }
}
