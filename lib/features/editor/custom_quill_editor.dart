import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CustomQuillEditor extends StatelessWidget {
  const CustomQuillEditor(
      {super.key,
      required this.controller,
      required this.configurations,
      required this.focusNode,
      required this.scrollController});
  final QuillController controller;
  final QuillEditorConfigurations configurations;
  final ScrollController scrollController;
  final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return QuillEditor(
      focusNode: focusNode,
      scrollController: scrollController,
      controller: controller,
      configurations: configurations.copyWith(),
    );
  }
}
