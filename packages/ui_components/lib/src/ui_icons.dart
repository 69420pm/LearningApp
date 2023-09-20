// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// all static icons
class UIIcons {
  /// arrow forward to indicate that an element is clickable
  static UIIcon arrowForwardNormal =
      UIIcon(Icons.arrow_forward_ios_rounded, size: 32);
  static UIIcon arrowForwardMedium =
      UIIcon(Icons.arrow_forward_ios_rounded, size: 24);
  static UIIcon arrowForwardSmall =
      UIIcon(Icons.arrow_forward_ios_rounded, size: 22);
  static UIIcon arrowDown = UIIcon(Icons.expand_more_rounded);
  static UIIcon arrowBack = UIIcon(Icons.arrow_back_rounded);
  static UIIcon add = UIIcon(Icons.add_rounded);
  static UIIcon download = UIIcon(Icons.file_download_outlined);
  static UIIcon account = UIIcon(Icons.account_circle_rounded);
  static UIIcon search = UIIcon(Icons.search_rounded);
  static UIIcon cancel = UIIcon(Icons.cancel_rounded);
  static UIIcon close = UIIcon(Icons.close_rounded, size: 32);
  static UIIcon card = UIIcon(Icons.article_outlined, size: 32);
  static UIIcon folder = UIIcon(Icons.folder_outlined);
  static UIIcon placeHolder = UIIcon(Icons.grid_4x4);
  static UIIcon settings = UIIcon(Icons.settings_outlined, size:32);
  static UIIcon addFolder = UIIcon(Icons.create_new_folder_rounded, size:32);
  static UIIcon share = UIIcon(Icons.share_rounded, size:32);
  static UIIcon classTest = UIIcon(Icons.calendar_month_rounded, size: 32,);
  static UIIcon edit = UIIcon(Icons.edit_rounded, size: 24,);
  static UIIcon delete = UIIcon(Icons.delete_rounded, size:26, color: UIColors.delete,);
  static UIIcon info = UIIcon(Icons.info_outline_rounded, size: 20);
  static UIIcon expandMore = UIIcon(Icons.expand_more_rounded, size: 32);
  static UIIcon done = UIIcon(Icons.done_rounded, size: 32,);
  static UIIcon formatBold = UIIcon(Icons.format_bold_rounded, size: 32);
  static UIIcon formatItalic = UIIcon(Icons.format_italic_rounded, size: 32);
  static UIIcon formatUnderline = UIIcon(Icons.format_underline_rounded, size: 32);
  static UIIcon alternateEmail = UIIcon(Icons.alternate_email_rounded, size: 32);
  static UIIcon formatColorText = UIIcon(Icons.format_color_text_rounded, size: 32);
  static UIIcon formatColorFill = UIIcon(Icons.format_color_fill_rounded, size: 32);
  static UIIcon bigTitle = UIIcon(Icons.title_rounded, size: 32);
  static UIIcon smallTitle = UIIcon(Icons.title_rounded, size: 24);
  static UIIcon horizontalRule = UIIcon(Icons.horizontal_rule_rounded, size: 32);
  static UIIcon formatListBulleted = UIIcon(Icons.format_list_bulleted_rounded, size: 32);
  static UIIcon formatListNumbered = UIIcon(Icons.format_list_numbered_rounded, size: 32);
  static UIIcon formatQuote = UIIcon(Icons.format_quote_rounded, size: 32);
  static UIIcon calloutTile = UIIcon(Icons.crop_16_9_rounded, size: 32);
  static UIIcon functions = UIIcon(Icons.functions_rounded, size: 32);
  static UIIcon image = UIIcon(Icons.image_outlined, size: 32);
  static UIIcon audio = UIIcon(Icons.audio_file_outlined, size: 32);
  static UIIcon circle = UIIcon(Icons.circle, size: 9);
  static UIIcon moreVert = UIIcon(Icons.more_vert_rounded, size:32);
  static UIIcon duplicate = UIIcon(Icons.content_copy_rounded, size: 28);
  static UIIcon emoji = UIIcon(Icons.emoji_emotions_rounded, size: 32);


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
