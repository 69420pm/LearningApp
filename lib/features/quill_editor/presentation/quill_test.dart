import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learning_app/features/quill_editor/presentation/custom_quill_editor.dart';
import 'package:learning_app/features/quill_editor/presentation/custom_quill_toolbar.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/cubit/editor_keyboard_row_cubit.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/editor_keyboard_row.dart';

class QuillTest extends StatelessWidget {
  const QuillTest({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = QuillController.basic();
    final _configurations = QuillEditorConfigurations();
    final _scrollController = ScrollController();
    final _focusNode = FocusNode();

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          // CustomQuillToolbar(controller: _controller),
          Expanded(
            child: CustomQuillEditor(
              controller: _controller,
              configurations: _configurations,
              scrollController: _scrollController,
              focusNode: _focusNode,
            ),
          ),
          BlocProvider(
            create: (context) =>
                EditorKeyboardRowCubit(controller: _controller),
            child: EditorKeyboardRow(
              controller: _controller,
            ),
          )
        ],
      )),
    );
  }
}
