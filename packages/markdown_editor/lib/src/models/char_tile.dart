import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CharTile extends Equatable {
  /// constructor
  CharTile({
    required this.text,
    required this.style,
    required this.isBold,
    required this.isItalic,
    required this.isUnderlined,
    this.isHyperlink = false,
  });

  /// text of charTile
  String text;

  /// style of char
  TextStyle style;

  /// whether text is bold
  bool isBold;

  /// whether text is italic
  bool isItalic;

  /// whether text is underlined
  bool isUnderlined;

  /// whether text is hyperlink
  bool isHyperlink;

  @override
  List<Object?> get props =>
      [text, style, isBold, isItalic, isUnderlined, isHyperlink];

  /// copyWith
  CharTile copyWith({
    String? char,
    TextStyle? style,
    bool? isDefaultOnBackgroundTextColor,
    bool? isBold,
    bool? isItalic,
    bool? isUnderlined,
    bool? isHyperlink,
  }) {
    return CharTile(
      text: char ?? this.text,
      style: style ?? this.style,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderlined: isUnderlined ?? this.isUnderlined,
      isHyperlink: isHyperlink ?? this.isHyperlink,
    );
  }
}
