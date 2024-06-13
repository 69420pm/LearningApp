// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TextEditorStyle extends Equatable {
  final bool isItalic;
  final bool isBold;
  final bool isUnderlined;
  final bool isStrikethrough;
  final EditorColor color;
  final EditorColor backgroundColor;
  final ParagraphStyle paragraphStyle;
  TextEditorStyle({
    this.isItalic = false,
    this.isBold = false,
    this.isUnderlined = false,
    this.isStrikethrough = false,
    this.color = EditorColor.white,
    this.backgroundColor = EditorColor.transparent,
    this.paragraphStyle = ParagraphStyle.body,
  });

  TextEditorStyle copyWith({
    bool? isItalic,
    bool? isBold,
    bool? isUnderlined,
    bool? isStrikethrough,
    EditorColor? color,
    EditorColor? backgroundColor,
    ParagraphStyle? paragraphStyle,
  }) {
    return TextEditorStyle(
      isItalic: isItalic ?? this.isItalic,
      isBold: isBold ?? this.isBold,
      isUnderlined: isUnderlined ?? this.isUnderlined,
      isStrikethrough: isStrikethrough ?? this.isStrikethrough,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      paragraphStyle: paragraphStyle ?? this.paragraphStyle,
    );
  }

  @override
  String toString() {
    return 'TextEditorStyle(isItalic: $isItalic, isBold: $isBold, isUnderlined: $isUnderlined, isStrikethrough: $isStrikethrough, color: $color, backgroundColor: $backgroundColor, paragraphStyle: $paragraphStyle)';
  }

  @override
  List<Object> get props {
    return [
      isItalic,
      isBold,
      isUnderlined,
      isStrikethrough,
      paragraphStyle,
      color,
      backgroundColor
    ];
  }
}

enum ParagraphStyle {
  title,
  heading,
  subheading,
  body,
  monostyled,
  bulletedList,
  numberedList,
  quote,
}

enum EditorColor {
  red,
  blue,
  green,
  yellow,
  orange,
  purple,
  brown,
  black,
  white,
  gray,
  transparent,
}
