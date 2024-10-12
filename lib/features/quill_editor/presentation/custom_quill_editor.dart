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
        ElevatedButton(
            onPressed: () => _addEditNote(context), child: Text('test')),
        QuillEditor(
          focusNode: focusNode,
          scrollController: scrollController,
          controller: controller,
          configurations: configurations.copyWith(
            embedBuilders: [ImageEmbedBuilder(addEditNote: _addEditNote)],
            onImagePaste: (imageBytes) {
              // TODO save image
              return Future.value('123');
            },
          ),
        ),
      ],
    );
  }

  Future<void> _addEditNote(BuildContext context, {Document? document}) async {
    final isEditing = document != null;
    final quillEditorController = QuillController(
      document: document ?? Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: const EdgeInsets.only(left: 16, top: 8),

        ///
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${isEditing ? 'Edit' : 'Add'} note'),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            )
          ],
        ),
        content: QuillEditor.basic(
          controller: quillEditorController,
          configurations: const QuillEditorConfigurations(),
        ),
      ),
    );

    if (quillEditorController.document.isEmpty()) return;

    final block = BlockEmbed.custom(
      ImageBlockEmbed.fromDocument(quillEditorController.document),
    );
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;

    if (isEditing) {
      final offset =
          getEmbedNode(controller, controller.selection.start).offset;
      controller.replaceText(
          offset, 1, block, TextSelection.collapsed(offset: offset));
    } else {
      controller.replaceText(index, length, block, null);
    }
  }
}
