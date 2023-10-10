import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/widgets/bottom_sheets/recorder_bottom_sheet.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/new_audio_tile.dart';
import 'package:ui_components/ui_components.dart';

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
            icon: UIIcons.mic,
            text: 'Record Audio',
            onPressed: () async {
              await UIBottomSheet.showUIBottomSheet(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<TextEditorBloc>(),
                  child: RecorderBottomSheet(),
                ),
              ).whenComplete(() => Navigator.of(context).pop());
            },
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          UIIconRow(
            icon: UIIcons.folderFilled,
            text: 'Upload File',
            onPressed: () async {
              final audio =
                  await FilePicker.platform.pickFiles(type: FileType.audio);

              if (audio != null && audio.files.single.path != null) {
                // avoid context async gaps
                if (context.mounted) {
                  context.read<TextEditorBloc>().add(
                        TextEditorAddEditorTile(
                          newEditorTile: NewAudioTile(
                            filePath: audio.files.single.path!,
                          ),
                          context: context,
                        ),
                      );
                }
              }
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
