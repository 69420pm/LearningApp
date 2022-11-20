import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIAppBar extends AppBar {
  UIAppBar({super.key, super.title, super.scrolledUnderElevation});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UISizeConstants.defaultSize * 4),
      child: this,
    );
  }
}
