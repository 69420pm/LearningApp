import 'dart:io';

import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/helper/audio_helper.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/new_audio_tile.dart';
import 'package:ui_components/ui_components.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecorderBottomSheet extends StatefulWidget {
  @override
  State<RecorderBottomSheet> createState() => _RecorderBottomSheetState();
}

class _RecorderBottomSheetState extends State<RecorderBottomSheet> {
  Directory? _directory;
  String? _filePath;
  String? _fileName;
  bool _isRecording = false;
  Future<void> toggleRecording(BuildContext context) async {
    _isRecording = await AudioHelper.toggleRecording(_filePath!);
    setState(() {
      _isRecording = _isRecording;
    });
    // recording finished
    if (!_isRecording) {
      // https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps
      if (context.mounted) {
        context.read<TextEditorBloc>().add(
              TextEditorAddEditorTile(
                newEditorTile: NewAudioTile(
                  filePath: _filePath!,
                ),
                context: context,
              ),
            );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _asyncInit();
  }

  Future<void> _asyncInit() async {
    if (await AudioHelper.initRecorder()) {
      _directory = await getApplicationDocumentsDirectory();
      _fileName = DateTime.now().toString();
    _filePath = '${_directory!.path}/$_fileName.aac';
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      title: const Text(
        'Record Audio',
        style: UIText.label,
      ),
      actionLeft: UIButton(
        onPressed: () {},
        child: Text(
          'Restart',
          style: UIText.labelBold.copyWith(color: UIColors.primary),
        ),
      ),
      actionRight: UIButton(
        onPressed: () {},
        child: Text(
          'Done',
          style: UIText.labelBold.copyWith(color: UIColors.primary),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: UIColors.onOverlayCard,
                        borderRadius:
                            BorderRadius.circular(UIConstants.cornerRadius),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: UIColors.onOverlayCard,
                  borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
                ),
                child: GestureDetector(
                  onTap: () => toggleRecording(context),
                  child: _isRecording ? UIIcons.account : UIIcons.mic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    AudioHelper.disposeRecorder();
    super.dispose();
  }
}
