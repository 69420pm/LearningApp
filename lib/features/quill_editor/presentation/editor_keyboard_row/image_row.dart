import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learning_app/features/quill_editor/helper/quill_helper.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/widgets/close_button.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/widgets/color_button.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/cubit/editor_keyboard_row_cubit.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/widgets/image_button.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/widgets/quill_toggle_button.dart';
// import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/quill_toggle_button.dart';

class EmbedBlockRow extends StatelessWidget {
  EmbedBlockRow({super.key, required this.controller});
  QuillController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: QuillToolbar(
        child: Row(
          children: [
            const KeyboardRowCloseButton(),
            ImageButton(),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.image_outlined)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.mic_outlined)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.brush_outlined)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.functions_outlined)),
          ],
        ),
      ),
    );
  }
}
