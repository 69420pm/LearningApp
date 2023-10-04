import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// constants for text fields, especially text styles for header1 or normal etc.
class TextFieldConstants {
  /// normal standard text style
  static const TextStyle normal = UIText.normalEditor;

  /// text style for h1
  static const TextStyle headingBig = UIText.titleBig;

  /// text style for h2
  static const TextStyle headingSmall =
      UIText.titleSmall;

  /// text style for quotes
  static TextStyle quote = UIText.quote;

  /// fontSize is zero
  static const TextStyle zero = TextStyle(fontSize: 0);

  /// text for index of orderedListTile
  static const TextStyle orderedListIndex = UIText.normalEditor;

  /// text style for the front textfield of the callout_tile
  /// which should get used for smileys
  static const TextStyle calloutStart = TextStyle(fontSize:20);

  // static const TextStyle textButton = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
}
