import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learning_app/features/quill_editor/presentation/image_embed_block.dart';

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
    return Column(
      children: [
        QuillEditor(
          focusNode: focusNode,
          scrollController: scrollController,
          controller: controller,
          configurations: configurations.copyWith(
            embedBuilders: [ImageEmbedBuilder(addEditNote: addImage)],
            onImagePaste: (imageBytes) {
              // TODO save image
              return Future.value('123');
            },
          ),
        ),
      ],
    );
  }
}
