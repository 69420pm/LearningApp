import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:markdown_editor/src/helper/audio_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

part 'audio_tile_state.dart';

class AudioTileCubit extends Cubit<AudioTileState> {
  AudioTileCubit() : super(AudioTileInitial()) {}

  bool _isRecording = false;
  bool _isPlaying = false;

  Duration? _duration;
  Duration? _position;

  final _audioPlayer = AudioPlayer();

  String? _filePath;
  String? _fileName;

  Directory? _directory;

  Future<void> initState(String fileName) async {
    _directory ??= await getApplicationDocumentsDirectory();
    _fileName = fileName;
    _filePath = _directory!.path + '/' + fileName;
    print(_filePath);
    if (File(_filePath!).existsSync() && state is! AudioTilePlayAudio) {
      _isPlaying = false;
      await switchToAudioPage();
    }
  }

  /// show initial page with option to record audio or choose file form storage
  void switchToInitPage() {
    emit(AudioTileInitial());
  }

  /// switch to recording page to record audio
  Future<void> switchToRecordingPage() async {
    if (await AudioHelper.initRecorder()) {
      _directory ??= await getApplicationDocumentsDirectory();
      _filePath = _directory!.path + '/' + _fileName!;
      _isRecording = false;
      emit(
        AudioTileRecordAudio(
          isRecording: _isRecording,
          stoppedRightNow: false,
        ),
      );
    }
  }

  /// toggle recording on or off
  void toggleRecording() async {
    _isRecording = await AudioHelper.toggleRecording(_filePath!);
    final stoppedRightNow = !_isRecording;
    if (stoppedRightNow) AudioHelper.disposeRecorder();
    emit(
      AudioTileRecordAudio(
        isRecording: _isRecording,
        stoppedRightNow: stoppedRightNow,
      ),
    );
  }

  /// load file from local storage and play it
  Future<void> loadFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      _filePath = result.files.single.path;
      await switchToAudioPage();
    }
  }

  Future<void> switchToAudioPage() async {
    _isRecording = false;
    _isPlaying = false;

    await _audioPlayer.setSourceUrl(_filePath!);
    _duration = await _audioPlayer.getDuration();
    AudioHelper.disposeRecorder();
    emit(
      AudioTilePlayAudio(
        isPlaying: _isPlaying,
        duration: _duration,
      ),
    );
  }

  void togglePlaying() async {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      await audioPlayer.play(DeviceFileSource(directory!.path + '/file.aac'));
      duration = await audioPlayer.getDuration();
      await _audioPlayer.play(DeviceFileSource(_filePath!),
          position: _position);
      // duration = await audioPlayer.getDuration();
    } else {
      await _audioPlayer.pause();
    }

    _position = null;

    _audioPlayer.onPlayerStateChanged.listen(
      (state) async {
        _isPlaying = state == PlayerState.playing;
        final position = await _audioPlayer.getCurrentPosition();
        emit(
          AudioTilePlayAudio(
            isPlaying: _isPlaying,
            duration: _duration,
            position: position,
          ),
        );
      },
    );

    _audioPlayer.onPositionChanged.listen(
      (newPosition) {
        emit(
          AudioTilePlayAudio(
              isPlaying: _isPlaying,
              position: newPosition,
              duration: _duration),
        );
      },
    );
  }

  Future<void> jumpTo(Duration position) async {
    await _audioPlayer.seek(position);
    this._position = position;
    emit(AudioTilePlayAudio(
        isPlaying: _isPlaying, position: position, duration: _duration));
  }
}
