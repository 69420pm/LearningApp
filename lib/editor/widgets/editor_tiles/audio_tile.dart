import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/models/text_field_controller.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';

class AudioTile extends StatefulWidget implements EditorTile {
  AudioTile({
    super.key,
    required this.filePath,
    this.inRenderMode = false,
  }) : super();

  String filePath;

  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;

  @override
  bool inRenderMode;

  @override
  State<AudioTile> createState() => _AudioTileState();
}

class _AudioTileState extends State<AudioTile> with TickerProviderStateMixin {
  bool _isPlaying = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final _audioPlayer = AudioPlayer();

  late final _fileSource = DeviceFileSource(widget.filePath);

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
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      await _audioPlayer.play(
        _fileSource,
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
        final position = await _audioPlayer.getCurrentPosition();
        if (position != null) {
          _position = position;
        }
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

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    // Use the DateFormat class to format the time components
    final formattedDuration = DateFormat('mm:ss').format(
      DateTime(0, 0, 0, 0, minutes, seconds),
    );

    return formattedDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.pageHorizontalPadding,
        vertical: UIConstants.itemPadding / 2,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: UIColors.overlay,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            overlayShape: SliderComponentShape.noOverlay,
                          ),
                          child: Slider(
                            max: _duration.inMilliseconds.toDouble(),
                            value: _position.inMilliseconds.toDouble(),
                            onChanged: (value) {
                              // jump to
                              setState(() {
                                _position =
                                    Duration(milliseconds: value.toInt());
                                _audioPlayer.seek(_position);
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 49,
                        child: Text(
                          formatDuration(_position),
                          style: UIText.label.copyWith(
                            color: _isPlaying
                                ? UIColors.primary
                                : UIColors.smallText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!widget.inRenderMode)
                UIIconButton(
                  icon: UIIcons.cancel
                      .copyWith(color: UIColors.background, size: 28),
                  animateToWhite: true,
                  onPressed: () {
                    context.read<TextEditorBloc>().add(
                          TextEditorRemoveEditorTile(
                            tileToRemove: widget,
                            context: context,
                          ),
                        );
                  },
                ),
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
