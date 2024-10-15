import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/cubit/editor_keyboard_row_cubit.dart';

class KeyboardRowCloseButton extends StatelessWidget {
  const KeyboardRowCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<EditorKeyboardRowCubit>().selectNothing();
      },
      icon: const Icon(Icons.close),
    );
  }
}
