// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'audio_tile_cubit.dart';

abstract class AudioTileState extends Equatable{}

class AudioTileInitial extends AudioTileState {
  @override
  List<Object?> get props => [];
}

class AudioTileRecordAudio extends AudioTileState {
  bool isRecording;
  bool stoppedRightNow;
  AudioTileRecordAudio({
    required this.isRecording,
    required this.stoppedRightNow,
  });
  @override
  List<Object?> get props => [isRecording];
}

class AudioTilePlayAudio extends AudioTileState{
  @override
  List<Object?> get props => [];
}
