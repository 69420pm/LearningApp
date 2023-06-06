import 'dart:io';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

abstract class AudioHelper {
  static FlutterSoundRecorder? _audioRecorder;
  static FlutterSoundPlayer? _audioPlayer;
  static bool _isRecorderInitialized = false;
  static Directory? _directory;

  bool get isRecording => _audioRecorder!.isRecording;

  /// initialize AudioHelper
  static Future<void> initRecorder() async {
    _audioRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission denied');
    }
    _directory = await getApplicationDocumentsDirectory();
    await _audioRecorder!.openAudioSession();
    _isRecorderInitialized = true;
    printDirectory();
  }

  /// start or stop recording according to current recording state
  static Future<bool> toggleRecording(String filePath) async {
    _audioRecorder!.isStopped
        ? await _recordAudio(_directory!.path + "/" + filePath)
        : await _stopRecordingAudio();
    return _audioRecorder!.isRecording;
  }

  static Future<void> _recordAudio(String filePath) async {
    if (!_isRecorderInitialized) return;

    await _audioRecorder!.startRecorder(toFile: filePath);
  }

  static Future<void> _stopRecordingAudio() async {
    if (!_isRecorderInitialized) return;

    await _audioRecorder!.stopRecorder();
    printDirectory();
  }

  /// dispose and clean up the audioRecorder
  static void disposeRecorder() {
    if (!_isRecorderInitialized) return;
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialized = false;
    _directory = null;
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

  static void printDirectory(){
     List<FileSystemEntity> content = _directory!.listSync();

    // Print the names of the files and directories
    for (var entity in content) {
      print("directory " + entity.path);
    }
  }
}
