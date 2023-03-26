import 'package:flutter/material.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_selectable.dart';

class KeyboardUpperRowExtraFormat extends StatelessWidget {
  const KeyboardUpperRowExtraFormat({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 20,
        // width: 100,
        child: Row(
          children: <Widget>[
            KeyboardSelectable(icon: const Icon(Icons.functions)),
            KeyboardSelectable(icon: const Icon(Icons.code)),
            KeyboardSelectable(icon: const Icon(Icons.tag)),
            KeyboardSelectable(icon: const Icon(Icons.alternate_email)),
          ],
        ),
      ),
    );
  }
}
