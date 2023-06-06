import 'package:flutter/material.dart';
import 'package:markdown_editor/src/cubit/audio_tile_cubit.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioTile extends StatelessWidget implements EditorTile {
  AudioTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocBuilder<AudioTileCubit, AudioTileState>(
            builder: (context, state) {
              if (state is AudioTileInitial) {
                return const _AudioInitial();
              } else if (state is AudioTileRecordAudio) {
                return _RecordAudio(
                  isRecording: state.isRecording,
                  stoppedRightNow: state.stoppedRightNow,
                );
              } else if (state is AudioTilePlayAudio) {
                return _PlayAudio(
                  isPlaying: state.isPlaying,
                  duration: state.duration,
                  position: state.position,
                );
              } else {
                return ErrorWidget("internal bloc error");
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioTile &&
          runtimeType == other.runtimeType &&
          focusNode == focusNode;

  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;
}

class _AudioInitial extends StatelessWidget {
  const _AudioInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        UIButton(
          onTap: () => context.read<AudioTileCubit>().switchToRecordingPage(),
          child: Row(
            children: [Icon(Icons.mic), Text('record')],
          ),
        ),
        UIButton(
          child: Row(children: [Icon(Icons.folder), Text('file')]),
        )
      ],
    );
  }
}

class _RecordAudio extends StatelessWidget {
  const _RecordAudio({
    super.key,
    required this.isRecording,
    required this.stoppedRightNow,
  });
  final bool isRecording;
  final bool stoppedRightNow;
  @override
  Widget build(BuildContext context) {
    if (stoppedRightNow) {
      context.read<AudioTileCubit>().switchToAudioPage();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          backgroundColor: isRecording ? Colors.red : Colors.black,
          child: IconButton(
            onPressed: () {
              context.read<AudioTileCubit>().toggleRecording();
            },
            icon: isRecording ? Icon(Icons.stop) : Icon(Icons.mic),
          ),
        ),
        Slider(
          min: 0,
          max: 1,
          value: 0.5,
          onChanged: (value) {},
        ),
      ],
    );
  }
}

class _PlayAudio extends StatelessWidget {
  _PlayAudio(
      {required this.isPlaying, Duration? duration, Duration? position}) {
    this.duration = duration ?? this.duration;
    this.position = position ?? this.position;
  }

  bool isPlaying;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          child: IconButton(
            icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            onPressed: () {
              context.read<AudioTileCubit>().togglePlaying();
            },
          ),
        ),
        Column(
          children: [
            Slider(
              max: duration.inMicroseconds.toDouble(),
              value: position.inMicroseconds.toDouble(),
              onChanged: (value) {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(position.inSeconds.toString()),
                Text(duration.inSeconds.toString())
              ],
            )
          ],
        )
      ],
    );
  }
}
