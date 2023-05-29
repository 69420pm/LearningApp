import 'package:flutter/material.dart';

class CharTile {
  CharTile({
    required this.char,
    required this.style,
    required this.isDefaultOnBackgroundTextColor,
  });

  String char;
  TextStyle style;
  bool isDefaultOnBackgroundTextColor;
}
