import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CharTile extends Equatable {
  CharTile(
      {required this.char,
      required this.style,
      required this.isDefaultOnBackgroundTextColor,
      required this.isBold,
      required this.isItalic,
      required this.isUnderlined,
      this.isHyperlink = false});

  /// single char
  String char;

  /// style of char
  TextStyle style;
  bool isDefaultOnBackgroundTextColor;
  bool isBold;
  bool isItalic;
  bool isUnderlined;
  bool isHyperlink;

  @override
  List<Object?> get props => [char, style, isDefaultOnBackgroundTextColor];

  CharTile copyWith(
      {String? char,
      TextStyle? style,
      bool? isDefaultOnBackgroundTextColor,
      bool? isBold,
      bool? isItalic,
      bool? isUnderlined,
      bool? isHyperlink}) {
    return CharTile(
        char: char ?? this.char,
        style: style ?? this.style,
        isDefaultOnBackgroundTextColor: isDefaultOnBackgroundTextColor ??
            this.isDefaultOnBackgroundTextColor,
        isBold: isBold ?? this.isBold,
        isItalic: isItalic ?? this.isItalic,
        isUnderlined: isUnderlined ?? this.isUnderlined,
        isHyperlink: isHyperlink ?? this.isHyperlink);
  }
}
