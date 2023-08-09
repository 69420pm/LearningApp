import 'package:flutter/material.dart';

class UIText {
  /// biggest and boldest font available, for really big titles
  static const titleBig = TextStyle(
    fontFamily: 'Inter',
    fontSize: 38,
    fontWeight: FontWeight.w900,
    letterSpacing: -38 * 0.02,
    height: 41.8 / 38,
  );

  /// 2nd biggest and boldest font available, for more important text
  static const labelBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    // letterSpacing: -16 * 0.02,
    height: 20.8 / 16,
  );

  /// 3rd biggest and boldest font available, for labels and short text
  static const label = TextStyle(
    fontFamily: 'Inter',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 20.8 / 18,
  );

  /// normal bold font for small but important text
  static const normalBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w800,
    height: 15.6 / 14,
  );

  /// normal font for longer smaller text
  static const normal = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 15.6 / 14,
  );

  /// smallest font for explain texts
  static const small = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 14 / 12,
  );
}
