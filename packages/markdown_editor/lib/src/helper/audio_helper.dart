import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class AudioHelper {
  static FlutterSoundRecorder? _audioRecorder;
  static bool _isRecorderInitialized = false;

  bool get isRecording => _audioRecorder!.isRecording;

  /// initialize AudioHelper
  static Future<bool> initRecorder() async {
    if (_audioRecorder != null) return false;
    _audioRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission denied');
    }
    if(storageStatus != PermissionStatus.granted){
      throw RecordingPermissionException('Storage permission denied');

    }
    await _audioRecorder!.openAudioSession();
    _isRecorderInitialized = true;
    return true;
  }

  /// start or stop recording according to current recording state
  static Future<bool> toggleRecording(String filePath) async {
    if (_audioRecorder!.isStopped) {
      await _recordAudio(filePath);
      return _audioRecorder!.isRecording;
    } else {
      await _stopRecordingAudio();
      disposeRecorder();
      return false;
    }
  }

  static Future<void> _recordAudio(String filePath) async {
    if (!_isRecorderInitialized) return;

    await _audioRecorder!.startRecorder(toFile: filePath);
  }

  static Future<void> _stopRecordingAudio() async {
    if (!_isRecorderInitialized) return;

    await _audioRecorder!.stopRecorder();
  }

  /// dispose and clean up the audioRecorder
  static void disposeRecorder() {
    if (!_isRecorderInitialized) return;
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialized = false;
  }

  // static Future<void> initPlayer() async{
  //   _audioPlayer = FlutterSoundPlayer();
  //   await _audioPlayer!.openAudioSession();
  // }

  // static Future<void> _playAudio(
  //   String filePath,
  //   VoidCallback whenFinished,
  // ) async {
  //   await _audioPlayer!
  //       .startPlayer(fromURI: filePath, whenFinished: whenFinished);
  // }

  // static Future<void> _stopAudio() async {
  //   await _audioPlayer!.stopPlayer();
  // }

  // /// start or stop playing according to current playing state
  // static Future<bool> togglePlaying({
  //   required String filePath,
  //   required VoidCallback whenFinished,
  // }) async {
  //   if (_audioPlayer!.isStopped) {
  //     await _playAudio(filePath, whenFinished);
  //   } else {
  //     await _stopAudio();
  //   }
  //   return _audioPlayer!.isPlaying;
  // }

  // static Future<void> disposePlayer() async{
  //   _audioPlayer!.closeAudioSession();
  //   _audioPlayer = null;
  // }
}
