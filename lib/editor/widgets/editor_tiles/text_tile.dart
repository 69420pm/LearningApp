import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/models/char_tile.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/models/text_field_constants.dart';
import 'package:learning_app/editor/models/text_field_controller.dart';

import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class TextTile extends StatelessWidget implements EditorTile {
  TextTile({
    super.key,
    required this.textStyle,
    this.padding = true,
    this.parentEditorTile,
    this.hintText = 'write anything',
    this.isDense = true,
    this.contentPadding,
    this.focusNode,
    this.onBackspaceDoubleClick,
    this.onSubmit,
    this.isDefaultOnBackgroundTextColor = true,
    this.charTiles,
    this.inRenderMode = false,
  }) {
    focusNode ??= FocusNode();
    textFieldController = TextFieldController(standardStyle: textStyle);
    if (textStyle == TextFieldConstants.normal) {
      contentPadding ??= const EdgeInsets.only(top: 6, bottom: 6);
    }
  }

  /// TextStyle of textfield and hint text
  final TextStyle textStyle;

  ///if true, textColor will be set to colorsScheme.onBackground and
  ///will be updated
  final bool isDefaultOnBackgroundTextColor;

  /// MUST BE SET when [TextTile] is not directly
  /// the [EditorTile] that get's accessed
  final EditorTile? parentEditorTile;

  /// hint text that gets shown when the textfield is empty
  final String hintText;

  /// whether the textfield should get condensed
  final bool? isDense;

  /// whether textfield should have horizontal padding
  bool padding;

  /// contentPadding o [TextField]
  EdgeInsetsGeometry? contentPadding;

  /// event which should get called when the backspace button
  /// get's pressed multiple times
  /// when empty the [parentEditorTile] gets deleted
  Function? onBackspaceDoubleClick;

  /// event gets fired when submit button of textfield gets pressed
  /// when empty a new textfield gets created below
  Function? onSubmit;

  bool isInit = true;

  final Map<int, CharTile>? charTiles;

  final FocusNode _rawKeyboardListenerNode = FocusNode();

  /// text field controller for text field which is responsible
  /// for text formatting such as bold, italic, etc.
  @override
  TextFieldController? textFieldController =
      TextFieldController(standardStyle: TextFieldConstants.normal);

  @override
  FocusNode? focusNode;

  @override
  bool inRenderMode;

  @override
  Widget build(BuildContext context) {
    if (charTiles != null && isInit == true) {
      textFieldController!.addText(charTiles!.values.toList(), context);
    }
    isInit = false;
    if (inRenderMode) {
      return RichText(
        text: TextSpan(
          style: textStyle,
          children: charTiles!.values
              .map(
                (e) => TextSpan(text: e.text, style: e.style),
              )
              .toList(),
        ),
      );
    } else {
      return BlocBuilder<TextEditorBloc, TextEditorState>(
        buildWhen: (previous, current) {
          if (current is! TextEditorKeyboardRowChanged) {
            return false;
          }
          if ((textFieldController!.selection.end -
                      textFieldController!.selection.start) >
                  0 &&
              focusNode == FocusManager.instance.primaryFocus) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          return RawKeyboardListener(
            focusNode: _rawKeyboardListenerNode,
            onKey: (event) {
              if (event.isKeyPressed(LogicalKeyboardKey.backspace) &&
                  focusNode!.hasFocus &&
                  textFieldController!.selection.start == 0 &&
                  textFieldController!.selection.end == 0) {
                final textEditorBloc = context.read<TextEditorBloc>();
                if (onBackspaceDoubleClick != null) {
                  onBackspaceDoubleClick!.call();
                }
                // remove heading, callout tile, list tile etc.
                // tile gets removed and transformed to normal text tile in
                // same line
                else if (parentEditorTile != null) {
                  final replacingTextTile = TextTile(
                    textStyle: TextFieldConstants.normal,
                  );
                  final tiles = <CharTile>[];
                  textFieldController!.charTiles.forEach((key, value) {
                    tiles.add(value);
                  });
                  replacingTextTile.textFieldController!
                      .addText(tiles, context);
                  textEditorBloc.add(
                    TextEditorReplaceEditorTile(
                      tileToRemove: parentEditorTile!,
                      newEditorTile: replacingTextTile,
                      context: context,
                      handOverText: true,
                    ),
                  );
                } else {
                  textEditorBloc.add(
                    TextEditorRemoveEditorTile(
                      tileToRemove: this,
                      context: context,
                      handOverText: true,
                    ),
                  );
                }
                /* else if (!(textEditorBloc.editorTiles.length == 1 &&
                  textEditorBloc.editorTiles[0] ==
                      (parentEditorTile ?? this))) {
                textEditorBloc.add(
                  TextEditorRemoveEditorTile(
                    tileToRemove:
                        parentEditorTile == null ? this : parentEditorTile!,
                    context: context,
                    handOverText: true,
                  ),
                );
              } else if (textEditorBloc.editorTiles.length == 1 &&
                  textEditorBloc.editorTiles[0] == (parentEditorTile ?? this)) {
                textEditorBloc.add(TextEditorReplaceEditorTile(
                    tileToRemove: parentEditorTile ?? this,
                    newEditorTile:
                        TextTile(textStyle: TextFieldConstants.normal),
                    context: context,
                    handOverText: true));
              } */
              }
              // if(event.isKeyPressed(LogicalKeyboardKey.enter)){
              //   print("enter");
              // }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: padding ? UIConstants.pageHorizontalPadding : 0,
              ),
              child: TextField(
                // autofocus: true,
                controller: textFieldController,
                focusNode: focusNode,
                textInputAction: TextInputAction.next,
                // textfield gets pushed 80 above keyboard, that textfield
                // doesn't get hided by keyboard row, standard is 20
                scrollPadding: const EdgeInsets.all(50),

                onSubmitted: (value) {
                  if (onSubmit != null) {
                    onSubmit?.call();
                  } else {
                    context.read<TextEditorBloc>().add(
                          TextEditorAddEditorTile(
                            newEditorTile: TextTile(
                              key: ValueKey(DateTime.now()),
                              isDefaultOnBackgroundTextColor:
                                  isDefaultOnBackgroundTextColor,
                              textStyle: TextFieldConstants.normal,
                            ),
                            context: context,
                          ),
                        );
                  }
                },
                onTap: () async {
                  if (textFieldController == null ||
                      textFieldController!.hyperLinks.isEmpty) {
                    return;
                  }
                  final entry = HyperLinkEntry.checkHyperLink(
                    textFieldController!.selection.start,
                    textFieldController!.hyperLinks,
                  );
                  if (textFieldController!.selection.end -
                              textFieldController!.selection.start ==
                          0 &&
                      entry != null &&
                      entry.start != textFieldController!.selection.start) {
                    var url = textFieldController!.text
                        .substring(entry.start, entry.end + 1);
                    if (!(url.contains('https') || url.contains('www'))) {
                      url = 'https://www.$url';
                    } else if (url[0] != 'h') {
                      url = 'https://$url';
                    }
                    // final Uri uri = Uri(scheme: "https", host:'www.youtube.com');
                    final uri = Uri.parse(url);
                    if (!await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw Exception('Could not launch url');
                    }
                  }
                },
                onEditingComplete: () {},
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: isDefaultOnBackgroundTextColor
                    ? textStyle.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      )
                    : textStyle,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  isDense: isDense,
                  hintStyle: textStyle.copyWith(color: UIColors.smallTextDark),
                  contentPadding: contentPadding,
                  labelStyle: TextFieldConstants.zero,
                  labelText: '',
                  // floatingLabelBehavior:  FloatingLabelBehavior.always
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
