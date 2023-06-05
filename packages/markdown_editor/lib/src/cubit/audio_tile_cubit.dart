import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:markdown_editor/src/helper/audio_helper.dart';

part 'audio_tile_state.dart';

class AudioTileCubit extends Cubit<AudioTileState> {
  AudioTileCubit() : super(AudioTileInitial());

  bool _isRecording = false;

  void switchToRecordingPage() {
    AudioHelper.init();
    _isRecording = false;
    emit(AudioTileRecordAudio(isRecording: _isRecording, stoppedRightNow: false));
  }

  void toggleRecording() async {
    _isRecording = await AudioHelper.toggleRecording('file.aac');
    final stoppedRightNow = !_isRecording;
    if(stoppedRightNow) AudioHelper.dispose();
    emit(AudioTileRecordAudio(isRecording: _isRecording, stoppedRightNow: stoppedRightNow));
  }

  void playAudio() {
    _isRecording = false;
    emit(AudioTilePlayAudio());
  }
}
