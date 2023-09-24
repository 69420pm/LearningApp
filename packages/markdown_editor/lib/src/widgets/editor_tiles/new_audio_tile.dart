import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewAudioTile extends StatefulWidget implements EditorTile {
  NewAudioTile({super.key, required this.filePath});

  String filePath;
  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;

  @override
  State<NewAudioTile> createState() => _NewAudioTileState();
}

class _NewAudioTileState extends State<NewAudioTile>
    with TickerProviderStateMixin {
  bool _isPlaying = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final _audioPlayer = AudioPlayer();

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  Future<void> togglePlaying() async {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      await _audioPlayer.play(
        DeviceFileSource(widget.filePath),
        position: _position,
      );
      await _animationController.forward();
      _duration = (await _audioPlayer.getDuration())!;
    } else {
      await _audioPlayer.pause();
      await _animationController.reverse();
    }
    _audioPlayer.onPlayerComplete.listen((event) {
      _animationController.reverse();
      setState(() {
        _position = Duration.zero;
      });
    });
    _audioPlayer.onPlayerStateChanged.listen(
      (state) async {
        _isPlaying = state == PlayerState.playing;
        _position = (await _audioPlayer.getCurrentPosition())!;
      },
    );

    _audioPlayer.onPositionChanged.listen(
      (newPosition) {
        setState(() {
          _position = newPosition;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.pageHorizontalPadding),
      child: Container(
        decoration: BoxDecoration(
            color: UIColors.overlay, borderRadius: BorderRadius.circular(100)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: togglePlaying,
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(UIConstants.cornerRadius),
                    color: UIColors.background,
                  ),
                  child: Center(
                    child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: _animationController,
                      size: UIConstants.iconSize,
                      color: UIColors.primary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        
                      ),
                      child: Slider(
                        max: _duration.inMilliseconds.toDouble(),
                        value: _position.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          // jump to
                          setState(() {
                            _position = Duration(milliseconds: value.toInt());
                            _audioPlayer.seek(_position);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                // width: 48,
                child: UIIconButton(
                  
                    icon: UIIcons.cancel
                        .copyWith(color: UIColors.background, size: 28),
                        animateToWhite: true,
                    onPressed: () {
                       context.read<TextEditorBloc>().add(
                      TextEditorRemoveEditorTile(
                        tileToRemove: widget,
                        handOverText: false,
                        context: context,
                      ),
                    );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
