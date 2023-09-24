import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/image_tile.dart';
import 'package:ui_components/ui_components.dart';

class ImageBottomSheet extends StatelessWidget {
  ImageBottomSheet({super.key, required this.parentEditorTile});
  ImageTile parentEditorTile;

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      title: const Text(
        'Image Settings',
        style: UIText.label,
      ),
      child: Column(
        children: [
          UIIconRow(
            icon: UIIcons.zoomIn,
            text: 'Full Screen',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => InteractiveViewer(
                  maxScale: 4,
                  minScale: 0.3,
                  panEnabled: false,
                  child: GestureDetector(
                    onVerticalDragStart: (details) => Navigator.of(context).pop(),
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.all(UIConstants.itemPadding),
                      child: Image.file(parentEditorTile.image),
                    ),
                  ),
                ),
                barrierDismissible: true,
              );
            },
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          UIIconRow(
            icon: UIIcons.alignment,
            text: 'Alignment',
            onPressed: () {
              UIBottomSheet.showUIBottomSheet(
                context: context,
                builder: (newContext) {
                  return BlocProvider.value(
                    value: context.read<TextEditorBloc>(),
                    child: UISelectionBottomSheet(
                      selectionText: ['Left', 'Centered', 'Right'],
                      selection: (index) {
                        Alignment alignment = Alignment.center;
                        if (index == 0) {
                          alignment = Alignment.centerLeft;
                        } else if (index == 1) {
                          alignment = Alignment.center;
                        } else if (index == 2) {
                          alignment = Alignment.centerRight;
                        }
                        context.read<TextEditorBloc>().add(
                              TextEditorReplaceEditorTile(
                                tileToRemove: parentEditorTile,
                                newEditorTile: parentEditorTile.copyWith(
                                  alignment: alignment,
                                ),
                                context: context,
                              ),
                            );
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          UIDeletionRow(
            deletionText: 'Delete Image',
            onPressed: () {
              context.read<TextEditorBloc>().add(
                    TextEditorRemoveEditorTile(
                      tileToRemove: parentEditorTile,
                      handOverText: false,
                      context: context,
                    ),
                  );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
