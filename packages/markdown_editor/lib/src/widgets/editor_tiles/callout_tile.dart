import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/bottom_sheets/callout_tile_bottom_sheet.dart';
import 'package:ui_components/ui_components.dart';

class CalloutTile extends StatelessWidget implements EditorTile {
  /// initialize CalloutTile
  CalloutTile({
    super.key,
    this.tileColor = UIColors.smallTextDark,
    TextTile? textTile,
    this.iconString = '🤪',
  }) {
    this.textTile = textTile ??
        TextTile(
          focusNode: focusNode,
          textStyle: TextFieldConstants.normal,
          parentEditorTile: this,
        );
    this.textTile.padding = false;
    textFieldController = this.textTile.textFieldController;
  }

  Color tileColor;
  String iconString;

  late final TextTile textTile;

  @override
  FocusNode? focusNode = FocusNode();

  @override
  TextFieldController? textFieldController;
  final TextEditingController emojiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emojiController.text = iconString;
    // textTile
    //   .onBackspaceDoubleClick = () {
    //     textTile.focusNode = FocusNode();
    //     final tiles = <CharTile>[];
    //     textTile.textFieldController!.charTiles.forEach((key, value) {
    //       tiles.add(value);
    //     });
    //     replacingTextTile.textFieldController!.addText(
    //       tiles,
    //       context,
    //     );
    //     context.read<TextEditorBloc>().add(
    //           TextEditorReplaceEditorTile(
    //             tileToRemove: this,
    //             newEditorTile: replacingTextTile,
    //             handOverText: true,
    //             context: context,
    //           ),
    //         );
    //   };

    return Padding(
      padding: const EdgeInsets.only(top: 4, left: UIConstants.pageHorizontalPadding, right: UIConstants.pageHorizontalPadding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(UIConstants.cornerRadiusSmall),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            // right: UIConstants.itemPadding,
            left: 4,
            top: UIConstants.itemPadding / 3,
            bottom: UIConstants.itemPadding / 3,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: GestureDetector(
                  child: Text(
                    emojiController.text,
                    style: TextFieldConstants.calloutStart,
                  ),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<TextEditorBloc>(),
                      child: UIEmojiPicker(
                        onEmojiClicked: (p0) {
                          emojiController.text = p0.emoji;
                          final newTile = copyWith(iconString: p0.emoji);
                          context.read<TextEditorBloc>().add(
                                TextEditorReplaceEditorTile(
                                  tileToRemove: this,
                                  newEditorTile: newTile,
                                  context: context,
                                  requestFocus: false,
                                ),
                              );

                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 0,
              ),
              Expanded(child: textTile),
              UIIconButton(
                icon: UIIcons.moreHoriz
                    .copyWith(size: 28, color: UIColors.smallTextDark),
                onPressed: () => UIBottomSheet.showUIBottomSheet(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<TextEditorBloc>(),
                    child: CalloutTileBottomSheet(parentEditorTile: this,),
                  ),
                ),
              ),
              const SizedBox(width: 4,),
            ],
          ),
        ),
      ),
    );
  }

  /// copy with function of CalloutTile
  CalloutTile copyWith({
    Color? tileColor,
    TextTile? textTile,
    String? iconString,
  }) {
    return CalloutTile(
      tileColor: tileColor ?? this.tileColor,
      textTile: textTile ?? this.textTile,
      iconString: iconString ?? this.iconString,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalloutTile &&
          runtimeType == other.runtimeType &&
          textTile == other.textTile &&
          focusNode == other.focusNode;
}
