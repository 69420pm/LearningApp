import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class AudioHelper {
  static FlutterSoundRecorder? _audioRecorder;
  static FlutterSoundPlayer? _audioPlayer;
  static bool _isRecorderInitialized = false;

  bool get isRecording => _audioRecorder!.isRecording;

  /// initialize AudioHelper
  static Future<void> init() async{
    _audioRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw RecordingPermissionException('Microphone permission denied');
    }
    await _audioRecorder!.openAudioSession();
    _isRecorderInitialized = true;
  }

  /// start or stop recording according to current recording state
  static Future<bool> toggleRecording(String filePath) async {
    _audioRecorder!.isStopped
        ? await _recordAudio(filePath)
        : await _stopRecordingAudio();
    return _audioRecorder!.isRecording;
  }

  static Future<void> _recordAudio(String filePath) async {
    if(!_isRecorderInitialized) return;

    await _audioRecorder!.startRecorder(toFile: filePath);
  }

  static Future<void> _stopRecordingAudio() async {
    if(!_isRecorderInitialized) return;
    
    await _audioRecorder!.stopRecorder();
  }

  /// dispose and clean up the audioRecorder
  static void dispose(){
    if(!_isRecorderInitialized) return;
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialized = false;
  }


  static Future _playAudio(String filePath) async{
    await _audioPlayer!.startPlayer(fromURI: filePath);
  }
}
