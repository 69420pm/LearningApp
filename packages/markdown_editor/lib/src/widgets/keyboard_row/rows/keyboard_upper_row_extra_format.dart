import 'package:flutter/material.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_selectable.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_toggle.dart';

class KeyboardUpperRowExtraFormat extends StatelessWidget {
  KeyboardUpperRowExtraFormat({super.key});
  bool isCode = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 20,
        // width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            KeyboardSelectable(icon: const Icon(Icons.functions)),
            KeyboardToggle(
              icon: const Icon(Icons.code),
              height: 20,
              width: 100,
              onPressed: () {
                isCode = !isCode;
                context.read<TextEditorBloc>().add(
                    TextEditorKeyboardRowChange(
                      isCode: isCode,
                    ),
                  );
              },
            ),
            KeyboardSelectable(icon: const Icon(Icons.tag)),
            KeyboardSelectable(icon: const Icon(Icons.alternate_email)),
          ],
        ),
      ),
    );
  }
}
