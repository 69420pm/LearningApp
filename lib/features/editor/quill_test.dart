import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learning_app/features/editor/custom_quill_editor.dart';
import 'package:learning_app/features/editor/custom_quill_toolbar.dart';

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
          CustomQuillToolbar(controller: _controller),
          Expanded(
            child: CustomQuillEditor(
              controller: _controller,
              configurations: _configurations,
              scrollController: _scrollController,
              focusNode: _focusNode,
            ),
          )
        ],
      )),
    );
  }
}
