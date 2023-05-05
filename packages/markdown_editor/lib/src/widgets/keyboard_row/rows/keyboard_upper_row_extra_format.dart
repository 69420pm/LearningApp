// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_toggle.dart';
import 'package:ui_components/ui_components.dart';

// ignore: must_be_immutable
class KeyboardUpperRowExtraFormat extends StatelessWidget {
  KeyboardUpperRowExtraFormat({super.key});
  bool isCode = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: UIConstants.defaultSize * 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const IconButton(
              icon: Icon(Icons.functions),
              onPressed: null,
            ),
            KeyboardToggle(
              icon: const Icon(Icons.code),
              onPressed: () {
                isCode = !isCode;
                context.read<TextEditorBloc>().add(
                      TextEditorKeyboardRowChange(
                        isCode: isCode,
                      ),
                    );
              },
            ),
            const IconButton(
              icon: Icon(Icons.tag),
              onPressed: null,
            ),
            const IconButton(
              icon: Icon(Icons.alternate_email),
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}
