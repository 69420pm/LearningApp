import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/callout_tile.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/new_rows/color_rows/color_selectors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_components/ui_components.dart';

class CalloutTileBottomSheet extends StatelessWidget {
  CalloutTileBottomSheet({super.key, required this.parentEditorTile});
  CalloutTile parentEditorTile;

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      title: Text(
        'Callout Tile Settings',
        style: UIText.label,
      ),
      child: Column(
        children: [
          UILabelRow(labelText: 'Color'),
          const SizedBox(
            height: UIConstants.itemPaddingSmall,
          ),
          _ColorPicker(
            parentEditorTile: parentEditorTile,
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          UIIconRow(
            icon: UIIcons.emoji,
            text: 'Change Icon',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<TextEditorBloc>(),
                  child: UIEmojiPicker(
                    onEmojiClicked: (p0) {
                      parentEditorTile.emojiController.text = p0.emoji;
                      final newTile =
                          parentEditorTile.copyWith(iconString: p0.emoji);
                      context.read<TextEditorBloc>().add(
                            TextEditorReplaceEditorTile(
                              tileToRemove: parentEditorTile,
                              newEditorTile: newTile,
                              context: context,
                              requestFocus: false,
                            ),
                          );

                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          UIDeletionRow(
            deletionText: 'Delete Callout Tile',
            onPressed: () {
              context.read<TextEditorBloc>().add(TextEditorRemoveEditorTile(
                  tileToRemove: parentEditorTile, handOverText: false, context: context));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _ColorPicker extends StatefulWidget {
  _ColorPicker({super.key, required this.parentEditorTile});
  EditorTile parentEditorTile;

  @override
  State<_ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<_ColorPicker> {
  List<bool> selectedColor = [false, false, false, false, false, false];

  void updateColor(Color color, BuildContext context) {
    setState(() {
      changeSelectedColor(color);
    });
    final newTile = (widget.parentEditorTile as CalloutTile).copyWith(
      tileColor: color,
      textTile: (widget.parentEditorTile as CalloutTile).textTile,
    );
    context.read<TextEditorBloc>().add(
          TextEditorReplaceEditorTile(
            tileToRemove: widget.parentEditorTile,
            newEditorTile: newTile,
            context: context,
            requestFocus: false,
          ),
        );
    Navigator.of(context).pop();
  }

  void changeSelectedColor(Color color) {
    if (color == UIColors.smallTextDark) {
      selectedColor[0] = true;
    } else if (color == UIColors.redTransparent) {
      selectedColor[1] = true;
    } else if (color == UIColors.yellowTransparent) {
      selectedColor[2] = true;
    } else if (color == UIColors.greenTransparent) {
      selectedColor[3] = true;
    } else if (color == UIColors.blueTransparent) {
      selectedColor[4] = true;
    } else if (color == UIColors.purpleTransparent) {
      selectedColor[5] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    changeSelectedColor((widget.parentEditorTile as CalloutTile).tileColor);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: UIColors.onOverlayCard,
        borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.cardHorizontalPadding,
          vertical: UIConstants.cardVerticalPadding,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ColorSelector(
                  color: UIColors.smallText,
                  selected: selectedColor[0],
                  onPressed: () => updateColor(UIColors.smallTextDark, context),
                ),
                _ColorSelector(
                  color: UIColors.red,
                  selected: selectedColor[1],
                  onPressed: () =>
                      updateColor(UIColors.redTransparent, context),
                ),
                _ColorSelector(
                  color: UIColors.yellow,
                  selected: selectedColor[2],
                  onPressed: () =>
                      updateColor(UIColors.yellowTransparent, context),
                ),
                _ColorSelector(
                  color: UIColors.green,
                  selected: selectedColor[3],
                  onPressed: () =>
                      updateColor(UIColors.greenTransparent, context),
                ),
                _ColorSelector(
                  color: UIColors.blue,
                  selected: selectedColor[4],
                  onPressed: () =>
                      updateColor(UIColors.blueTransparent, context),
                ),
                _ColorSelector(
                  color: UIColors.purple,
                  selected: selectedColor[5],
                  onPressed: () =>
                      updateColor(UIColors.purpleTransparent, context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSelector extends StatelessWidget {
  _ColorSelector({
    super.key,
    required this.color,
    required this.onPressed,
    this.selected = false,
  });
  Color color;
  void Function() onPressed;
  bool selected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected ? UIColors.smallText : Colors.transparent,
                  borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
                ),
              ),
            ),
            Positioned(
              top: 3,
              left: 3,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: UIColors.onOverlayCard,
                  borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
