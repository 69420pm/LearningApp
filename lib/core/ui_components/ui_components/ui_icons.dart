// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';

/// all static icons
class UIIcons {
  /// arrow forward to indicate that an element is clickable
  static UIIcon arrowForwardNormal =
      const UIIcon(Icons.arrow_forward_ios_rounded, size: 32);
  static UIIcon arrowForwardMedium =
      const UIIcon(Icons.arrow_forward_ios_rounded, size: 24);
  static UIIcon arrowForwardSmall =
      const UIIcon(Icons.arrow_forward_ios_rounded, size: 22);
  static UIIcon arrowBackNormal =
      const UIIcon(Icons.arrow_back_ios_new_rounded, size: 32);
  static UIIcon arrowDown = const UIIcon(Icons.expand_more_rounded);
  static UIIcon arrowBack = const UIIcon(Icons.arrow_back_rounded);
  static UIIcon add = const UIIcon(Icons.add_rounded);
  static UIIcon download = const UIIcon(Icons.file_download_outlined);
  static UIIcon account = const UIIcon(Icons.account_circle_rounded);
  static UIIcon search = const UIIcon(Icons.search_rounded);
  static UIIcon cancel = const UIIcon(Icons.cancel_rounded);
  static UIIcon close = const UIIcon(Icons.close_rounded, size: 32);
  static UIIcon card = const UIIcon(Icons.article_outlined, size: 32);
  static UIIcon folder = const UIIcon(Icons.folder_outlined);
  static UIIcon folderFilled = const UIIcon(Icons.folder_rounded, size: 32);
  static UIIcon placeHolder = const UIIcon(Icons.grid_4x4);
  static UIIcon settings = const UIIcon(Icons.settings_outlined, size: 32);
  static UIIcon addFolder =
      const UIIcon(Icons.create_new_folder_rounded, size: 32);
  static UIIcon share = const UIIcon(Icons.share_rounded, size: 32);
  static UIIcon classTest = const UIIcon(
    Icons.calendar_month_rounded,
    size: 32,
  );
  static UIIcon edit = const UIIcon(
    Icons.edit_rounded,
    size: 24,
  );
  static UIIcon delete = const UIIcon(
    Icons.delete_rounded,
    size: 26,
    color: UIColors.delete,
  );
  static UIIcon info = const UIIcon(Icons.info_outline_rounded, size: 20);
  static UIIcon expandMore = const UIIcon(Icons.expand_more_rounded, size: 32);
  static UIIcon done = const UIIcon(
    Icons.done_rounded,
    size: 32,
  );
  static UIIcon formatBold = const UIIcon(Icons.format_bold_rounded, size: 32);
  static UIIcon formatItalic =
      const UIIcon(Icons.format_italic_rounded, size: 32);
  static UIIcon formatUnderline =
      const UIIcon(Icons.format_underline_rounded, size: 32);
  static UIIcon alternateEmail =
      const UIIcon(Icons.alternate_email_rounded, size: 32);
  static UIIcon formatColorText =
      const UIIcon(Icons.format_color_text_rounded, size: 32);
  static UIIcon formatColorFill =
      const UIIcon(Icons.format_color_fill_rounded, size: 32);
  static UIIcon bigTitle = const UIIcon(Icons.title_rounded, size: 32);
  static UIIcon smallTitle = const UIIcon(Icons.title_rounded, size: 24);
  static UIIcon horizontalRule =
      const UIIcon(Icons.horizontal_rule_rounded, size: 32);
  static UIIcon formatListBulleted =
      const UIIcon(Icons.format_list_bulleted_rounded, size: 32);
  static UIIcon formatListNumbered =
      const UIIcon(Icons.format_list_numbered_rounded, size: 32);
  static UIIcon formatQuote =
      const UIIcon(Icons.format_quote_rounded, size: 32);
  static UIIcon calloutTile = const UIIcon(Icons.crop_16_9_rounded, size: 32);
  static UIIcon functions = const UIIcon(Icons.functions_rounded, size: 32);
  static UIIcon image = const UIIcon(Icons.image_outlined, size: 32);
  static UIIcon audio = const UIIcon(Icons.audio_file_outlined, size: 32);
  static UIIcon circle = const UIIcon(Icons.circle, size: 9);
  static UIIcon moreHoriz = const UIIcon(Icons.more_horiz_rounded, size: 26);
  static UIIcon duplicate = const UIIcon(Icons.content_copy_rounded, size: 28);
  static UIIcon emoji = const UIIcon(Icons.emoji_emotions_rounded, size: 32);
  static UIIcon camera = const UIIcon(Icons.photo_camera_rounded, size: 32);
  static UIIcon photoLibrary =
      const UIIcon(Icons.photo_library_rounded, size: 32);
  static UIIcon zoomIn = const UIIcon(Icons.zoom_in_rounded, size: 32);
  static UIIcon alignment =
      const UIIcon(Icons.format_align_center_rounded, size: 32);
  static UIIcon mic = const UIIcon(Icons.mic_rounded, size: 32);
  static UIIcon stopCircle = const UIIcon(Icons.stop_circle, size: 32);
  static UIIcon curlyBraces = const UIIcon(Icons.data_object_rounded, size: 32);
  static UIIcon arrowRight =
      const UIIcon(Icons.arrow_right_alt_rounded, size: 32);
  static UIIcon superscript = const UIIcon(Icons.superscript_rounded, size: 28);
  static UIIcon subscript = const UIIcon(Icons.subscript_rounded, size: 28);
  static UIIcon spaceBar = const UIIcon(Icons.space_bar_rounded, size: 32);
  static UIIcon chevronRight =
      const UIIcon(Icons.chevron_right_outlined, size: 36);
  static UIIcon chevronLeft =
      const UIIcon(Icons.chevron_left_outlined, size: 36);
  static UIIcon debug = const UIIcon(Icons.flutter_dash_rounded, size: 36);
  static UIIcon selectAll = const UIIcon(Icons.select_all_rounded, size: 36);
  static UIIcon link = const UIIcon(Icons.link_rounded, size: 32);
  static UIIcon reorder = const UIIcon(Icons.reorder_rounded, size: 32);
  static UIIcon dragIndicator =
      const UIIcon(Icons.drag_indicator_rounded, size: 32);
}

class UIIcon extends Icon {
  const UIIcon(
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
