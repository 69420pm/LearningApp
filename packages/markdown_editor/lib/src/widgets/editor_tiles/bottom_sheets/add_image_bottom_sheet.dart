import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/helper/image_helper.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/image_tile.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddImageBottomSheet extends StatelessWidget {
  AddImageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      title: const Text(
        'Import Image',
        style: UIText.label,
      ),
      child: Column(
        children: [
          UIIconRow(
            icon: UIIcons.camera,
            text: 'From Camera',
            onPressed: () async {
              final image = await ImageHelper.pickImageCamera();
              if (image != null) {
                if(context.mounted){
context.read<TextEditorBloc>().add(
                      TextEditorAddEditorTile(
                        newEditorTile: ImageTile(image: image),
                        context: context,
                      ),
                    );
                }
                
              }
              if(context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          UIIconRow(
            icon: UIIcons.photoLibrary,
            text: 'From Gallery',
            onPressed: () async {
              final image = await ImageHelper.pickImageGallery();
              if (image != null) {
                if(context.mounted){
context.read<TextEditorBloc>().add(
                      TextEditorAddEditorTile(
                        newEditorTile: ImageTile(image: image),
                        context: context,
                      ),
                    );
                }
                
              }
              if(context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
