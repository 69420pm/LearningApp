// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// all static icons
class UIIcons {
  /// arrow forward to indicate that an element is clickable
  static UIIcon arrowForwardNormal = UIIcon(Icons.arrow_forward_ios_rounded, size: 32);
  static UIIcon arrowForwardMedium = UIIcon(Icons.arrow_forward_ios_rounded, size: 24);
  static UIIcon arrowForwardSmall = UIIcon(Icons.arrow_forward_ios_rounded, size: 22);
  static UIIcon arrowDown = UIIcon(Icons.expand_more_rounded);
  static UIIcon arrowBack = UIIcon(Icons.arrow_back_rounded);
  static UIIcon add = UIIcon(Icons.add_rounded);
  static UIIcon download = UIIcon(Icons.file_download_outlined);
  static UIIcon account = UIIcon(Icons.account_circle_rounded);
  static UIIcon search = UIIcon(Icons.search_rounded);
  static UIIcon cancel = UIIcon(Icons.cancel_rounded);
  static UIIcon card = UIIcon(Icons.article_outlined, size: 32);
  static UIIcon folder = UIIcon(Icons.folder_outlined);
  static UIIcon placeHolder = UIIcon(Icons.grid_4x4);
}

class UIIcon extends Icon {
  UIIcon(
    super.icon, {
    super.key,
    super.size,
    super.fill,
    super.weight,
    super.grade,
    super.opticalSize,
    super.color,
    super.shadows,
    super.semanticLabel,
    super.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      key: key,
      size: size ?? 32,
      fill: fill,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      color: color ?? UIColors.textLight,
      shadows: shadows,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }

  UIIcon copyWith({
    IconData? icon,
    Key? key,
    double? size,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    Color? color,
    List<Shadow>? shadows,
    String? semanticLabel,
    TextDirection? textDirection,
  }) {
    return UIIcon(
      icon ?? this.icon,
      key: key ?? this.key,
      size: size ?? this.size,
      fill: fill ?? this.fill,
      weight: weight ?? this.weight,
      grade: grade ?? this.grade,
      opticalSize: opticalSize ?? this.opticalSize,
      color: color ?? this.color,
      shadows: shadows ?? this.shadows,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      textDirection: textDirection ?? this.textDirection,
    );
  }
}
