// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field_manager.dart';

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

class EditorTextStyle extends TextStyle {
  LineFormatType lineFormatType;
  EditorTextStyle({
    this.lineFormatType = LineFormatType.body,
    TextStyle style = const TextStyle(),
  }) : super(
          inherit: style.inherit,
          color: style.color,
          backgroundColor: style.backgroundColor,
          fontSize: style.fontSize,
          fontWeight: style.fontWeight,
          fontStyle: style.fontStyle,
          letterSpacing: style.letterSpacing,
          wordSpacing: style.wordSpacing,
          textBaseline: style.textBaseline,
          height: style.height,
          leadingDistribution: style.leadingDistribution,
          locale: style.locale,
          foreground: style.foreground,
          background: style.background,
          shadows: style.shadows,
          fontFeatures: style.fontFeatures,
          fontVariations: style.fontVariations,
          decoration: style.decoration,
          decorationColor: style.decorationColor,
          decorationStyle: style.decorationStyle,
          decorationThickness: style.decorationThickness,
          debugLabel: style.debugLabel,
          fontFamily: style.fontFamily,
          fontFamilyFallback: style.fontFamilyFallback,
          overflow: style.overflow,
        );

  @override
  EditorTextStyle copyWith({
    LineFormatType? lineFormatType,
    bool? inherit,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    List<FontVariation>? fontVariations,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    TextOverflow? overflow,
  }) {
    return EditorTextStyle(
      lineFormatType: lineFormatType ?? this.lineFormatType,
      style: super.copyWith(
        inherit: inherit,
        color: color,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        leadingDistribution: leadingDistribution,
        locale: locale,
        foreground: foreground,
        background: background,
        shadows: shadows,
        fontFeatures: fontFeatures,
        fontVariations: fontVariations,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        debugLabel: debugLabel,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        overflow: overflow,
      ),
    );
  }
}
