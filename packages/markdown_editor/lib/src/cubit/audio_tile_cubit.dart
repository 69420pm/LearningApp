import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:markdown_editor/src/helper/audio_helper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

part 'audio_tile_state.dart';

class AudioTileCubit extends Cubit<AudioTileState> {
  AudioTileCubit() : super(AudioTileInitial()) {}

  bool _isRecording = false;
  bool _isPlaying = false;

  final audioPlayer = AudioPlayer();

  Directory? directory;

  void switchToRecordingPage() {
    AudioHelper.initRecorder();
    _isRecording = false;
    emit(
      AudioTileRecordAudio(
        isRecording: _isRecording,
        stoppedRightNow: false,
      ),
    );
  }

  void toggleRecording() async {
    _isRecording = await AudioHelper.toggleRecording('file.aac');
    final stoppedRightNow = !_isRecording;
    if (stoppedRightNow) AudioHelper.disposeRecorder();
    emit(
      AudioTileRecordAudio(
        isRecording: _isRecording,
        stoppedRightNow: stoppedRightNow,
      ),
    );
  }

  Future<void> switchToAudioPage() async {
    _isRecording = false;
    _isPlaying = false;
    directory ??= await getApplicationDocumentsDirectory();

    await audioPlayer.setSourceUrl(directory!.path + '/file.aac');
    emit(
      AudioTilePlayAudio(
        isPlaying: _isPlaying,
        duration: await audioPlayer.getDuration(),
      ),
    );
  }

  void togglePlaying() async {
    _isPlaying = !_isPlaying;
    directory ??= await getApplicationDocumentsDirectory();
    Duration? duration = Duration.zero;
    if (_isPlaying) {

      await audioPlayer.play(DeviceFileSource(directory!.path + '/file.aac'));
      duration = await audioPlayer.getDuration();
    } else {
      await audioPlayer.pause();
    }

    audioPlayer.onPlayerStateChanged.listen(
      (state) {
        _isPlaying = state == PlayerState.playing;
        emit(
          AudioTilePlayAudio(isPlaying: _isPlaying, duration: duration),
        );
      },
    );

    audioPlayer.onPositionChanged.listen(
      (newPosition) {
        emit(
          AudioTilePlayAudio(
            isPlaying: _isPlaying,
            position: newPosition,
            duration: duration,
          ),
        );
      },
    );
  }
}
