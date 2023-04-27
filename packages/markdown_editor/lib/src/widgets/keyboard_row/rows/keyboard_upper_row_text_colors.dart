import 'package:flutter/material.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_selectable.dart';

class KeyboardUpperRowTextColors extends StatelessWidget {
  const KeyboardUpperRowTextColors({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 40,
        // width: 100,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _KeyboardColorSelectable(
                    color: Colors.white,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textColor: TextColor.white,
                          ),
                        ),
                  ),
                  _KeyboardColorSelectable(
                    color: Colors.white60,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textColor: TextColor.white60,
                          ),
                        ),
                  ),
                  _KeyboardColorSelectable(
                    color: Colors.white38,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textColor: TextColor.white38,
                          ),
                        ),
                  ),
                  _KeyboardColorSelectable(
                    color: Colors.brown,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textColor: TextColor.brown,
                          ),
                        ),
                  ),
                  _KeyboardColorSelectable(
                    color: Colors.orange,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textColor: TextColor.orange,
                          ),
                        ),
                  ),
                  _KeyboardColorSelectable(
                    color: Colors.yellow,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textColor: TextColor.yellow,
                          ),
                        ),
                  ),
                  _KeyboardColorSelectable(
                    color: Colors.green,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textColor: TextColor.green,
                          ),
                        ),
                  ),
                  _KeyboardColorSelectable(
                    color: Colors.blue,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textColor: TextColor.blue,
                          ),
                        ),
                  ),
                  _KeyboardColorSelectable(
                    color: Colors.purple,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textColor: TextColor.purple,
                          ),
                        ),
                  ),
                  _KeyboardColorSelectable(
                    color: Colors.pink,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textColor: TextColor.pink,
                          ),
                        ),
                  ),
                  _KeyboardColorSelectable(
                    color: Colors.red,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(textColor: TextColor.red),
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _KeyboardBackgroundColorSelectable(
                    color: Colors.white,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textBackgroundColor: TextBackgroundColor.noBG,
                          ),
                        ),
                  ),
                  _KeyboardBackgroundColorSelectable(
                    color: Colors.white60,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textBackgroundColor: TextBackgroundColor.white60BG,
                          ),
                        ),
                  ),
                  _KeyboardBackgroundColorSelectable(
                    color: Colors.white38,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textBackgroundColor: TextBackgroundColor.white38BG,
                          ),
                        ),
                  ),
                  _KeyboardBackgroundColorSelectable(
                    color: Colors.brown,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textBackgroundColor: TextBackgroundColor.brownBG,
                          ),
                        ),
                  ),
                  _KeyboardBackgroundColorSelectable(
                    color: Colors.orange,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textBackgroundColor: TextBackgroundColor.orangeBG,
                          ),
                        ),
                  ),
                  _KeyboardBackgroundColorSelectable(
                    color: Colors.yellow,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textBackgroundColor: TextBackgroundColor.yellowBG,
                          ),
                        ),
                  ),
                  _KeyboardBackgroundColorSelectable(
                    color: Colors.green,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textBackgroundColor: TextBackgroundColor.greenBG,
                          ),
                        ),
                  ),
                  _KeyboardBackgroundColorSelectable(
                    color: Colors.blue,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textBackgroundColor: TextBackgroundColor.blueBG,
                          ),
                        ),
                  ),
                  _KeyboardBackgroundColorSelectable(
                    color: Colors.purple,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textBackgroundColor: TextBackgroundColor.purpleBG,
                          ),
                        ),
                  ),
                  _KeyboardBackgroundColorSelectable(
                    color: Colors.pink,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textBackgroundColor: TextBackgroundColor.pinkBG,
                          ),
                        ),
                  ),
                  _KeyboardBackgroundColorSelectable(
                    color: Colors.red,
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorKeyboardRowChange(
                            textBackgroundColor: TextBackgroundColor.redBG,
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyboardColorSelectable extends StatelessWidget {
  _KeyboardColorSelectable({super.key, required this.color, this.onPressed});
  Color color;
  Function? onPressed;
  @override
  Widget build(BuildContext context) {
    return KeyboardSelectable(
      icon: Icon(
        Icons.format_color_text,
        color: color,
      ),
      width: 40,
      onPressed: onPressed,
    );
  }
}

class _KeyboardBackgroundColorSelectable extends StatelessWidget {
  _KeyboardBackgroundColorSelectable({
    super.key,
    required this.color,
    this.onPressed,
  });
  Color color;
  Function? onPressed;
  @override
  Widget build(BuildContext context) {
    return KeyboardSelectable(
      icon: Icon(
        Icons.format_color_fill,
        color: color,
      ),
      width: 40,
      onPressed: onPressed,
    );
  }
}
