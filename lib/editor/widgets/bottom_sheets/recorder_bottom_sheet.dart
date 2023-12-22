import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/widgets/editor_tiles/audio_tile.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_button.dart';
import 'package:learning_app/ui_components/widgets/dialogs/ui_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecorderBottomSheet extends StatefulWidget {
  const RecorderBottomSheet({super.key});

  @override
  State<RecorderBottomSheet> createState() => _RecorderBottomSheetState();
}

class _RecorderBottomSheetState extends State<RecorderBottomSheet> {
  bool? _microphonePermissionGranted;
  Timer? _timer;
  Duration _elapsedTime = const Duration();

  final _recorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _asyncInit();
    });
  }

  Future<void> _asyncInit() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      setState(() {
        _microphonePermissionGranted = false;
      });
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (_) => UIDialog(
            title: 'Microphone permission denied',
            body:
                'To use the recorder feature, please grant permission for microphone',
            actions: [
              UIButton(
                child: Text(
                  'Cancel',
                  style: UIText.label.copyWith(color: UIColors.primary),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              UIButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Grant Permission',
                  style: UIText.labelBold.copyWith(color: UIColors.primary),
                ),
              ),
            ],
          ),
        ).whenComplete(() => Navigator.of(context).pop());
      }
    } else {
      setState(() {
        _microphonePermissionGranted = true;
      });
      await _recorder.openRecorder();
      await _startRecording();
    }
  }

  Future<void> _stopRecording(BuildContext context) async {
    // stop
    final filePath = await _recorder.stopRecorder();
    // https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps
    if (context.mounted) {
      context.read<TextEditorBloc>().add(
            TextEditorAddEditorTile(
              newEditorTile: AudioTile(
                filePath: filePath!,
              ),
              context: context,
            ),
          );
      Navigator.of(context).pop();
    }
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    // Use the DateFormat class to format the time components
    final formattedDuration = DateFormat('HH:mm:ss').format(
      DateTime(0, 0, 0, hours, minutes, seconds),
    );

    return formattedDuration;
  }

  Future<void> _startRecording() async {
    final path = await getApplicationDocumentsDirectory();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _elapsedTime += const Duration(seconds: 1);
      });
    });
    // play

    await _recorder.startRecorder(
        toFile: '${path.path}/${Uid().uidNoSpecialCharacters()}.aac');
  }

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      title: const Text(
        'Record Audio',
        style: UIText.label,
      ),
      // actionLeft: UIButton(
      //   onPressed: () {},
      //   child: Text(
      //     'Restart',
      //     style: UIText.labelBold.copyWith(color: UIColors.primary),
      //   ),
      // ),
      // actionRight: UIButton(
      //   onPressed: () {},
      //   child: Text(
      //     'Done',
      //     style: UIText.labelBold.copyWith(color: UIColors.primary),
      //   ),
      // ),
      child: Column(
        children: [
          Builder(
            builder: (context) {
              if (_microphonePermissionGranted != null &&
                  _microphonePermissionGranted!) {
                // _startRecording();
                return Text(
                  formatDuration(_elapsedTime),
                  style: UIText.label.copyWith(color: UIColors.smallText),
                );
              } else {
                return Text(
                  '00:00:00',
                  style: UIText.label.copyWith(color: UIColors.smallText),
                );
              }
            },
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          Center(
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: UIColors.delete,
                borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _stopRecording(context);
                },
                child: Center(
                  child: Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: UIColors.textLight,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _timer?.cancel();

    super.dispose();
  }
}
