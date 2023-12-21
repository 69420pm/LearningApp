import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/widgets/editor_tiles/image_tile.dart';
import 'package:learning_app/editor/widgets/image_widgets/image_full_screen.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class ImageBottomSheet extends StatelessWidget {
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
                builder: (_) => ImageFullScreen(image: parentEditorTile.image),
                barrierDismissible: true,
              ).whenComplete(() => Navigator.of(context).pop());
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
                      selectionText: const ['Left', 'Centered', 'Right'],
                      selection: (index) {
                        var alignment = Alignment.center;
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
