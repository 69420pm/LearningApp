import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/helper/image_helper.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/audio_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/image_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/new_audio_tile.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

class AddAudioBottomSheet extends StatelessWidget {
  AddAudioBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      title: const Text(
        'Record Audio',
        style: UIText.label,
      ),
      child: Column(
        children: [
          UIIconRow(
            icon: UIIcons.camera,
            text: 'Upload Audio',
            onPressed: () async {
              final audio =
                  await FilePicker.platform.pickFiles(type: FileType.audio);

              if (audio != null && audio!.files.single.path != null) {
                context.read<TextEditorBloc>().add(
                      TextEditorAddEditorTile(
                        newEditorTile: NewAudioTile(
                          filePath: audio.files.single.path!,
                        ),
                        context: context,
                      ),
                    );
              }
              Navigator.of(context).pop();
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
                context.read<TextEditorBloc>().add(
                      TextEditorAddEditorTile(
                        newEditorTile: ImageTile(image: image),
                        context: context,
                      ),
                    );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
