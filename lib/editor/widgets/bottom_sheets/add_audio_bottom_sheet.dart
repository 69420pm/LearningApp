import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/widgets/bottom_sheets/recorder_bottom_sheet.dart';
import 'package:learning_app/editor/widgets/editor_tiles/audio_tile.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class AddAudioBottomSheet extends StatelessWidget {
  const AddAudioBottomSheet({super.key});

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
                  child: const RecorderBottomSheet(),
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
                          newEditorTile: AudioTile(
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
