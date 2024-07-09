import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

abstract class EditorTextStyles {
  // line text styles
  static const TextStyle heading = TextStyle(fontSize: 26, height: 3);
  static const TextStyle subheading = TextStyle(fontSize: 20, height: 2.5);
  static const TextStyle body = TextStyle(fontSize: 16);
  // text styles
  static const TextStyle bold = TextStyle(fontWeight: FontWeight.bold);
  static const TextStyle italic = TextStyle(fontStyle: FontStyle.italic);
  static const TextStyle underline =
      TextStyle(decoration: TextDecoration.underline);
  static const TextStyle strikethrough =
      TextStyle(decoration: TextDecoration.lineThrough);
}
