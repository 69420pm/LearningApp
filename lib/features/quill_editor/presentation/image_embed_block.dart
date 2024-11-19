import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/cubit/editor_bloc.dart';

class ImageBlockEmbed extends CustomBlockEmbed {
  const ImageBlockEmbed(String value) : super(imageType, value);

  static const String imageType = 'notes';

  static ImageBlockEmbed fromDocument(Document document) =>
      ImageBlockEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class ImageEmbedBuilder extends EmbedBuilder {
  ImageEmbedBuilder({required this.addEditNote});

  Future<void> Function(QuillController controller, BuildContext context,
      {Document? document}) addEditNote;

  @override
  String get key => 'notes';

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final filePath = context.read<EditorBloc>().imagePath;

    return GestureDetector(
        onTap: () {
          print(context
              .read<EditorBloc>()
              .controller
              .document
              .toDelta()
              .toJson());
        },
        child: Image.file(File(filePath!)));

    // return Material(
    //   color: Colors.transparent,
    //   child: ListTile(
    //     title: Text(
    //       notes.toPlainText().replaceAll('\n', ' '),
    //       maxLines: 3,
    //       overflow: TextOverflow.ellipsis,
    //     ),
    //     leading: const Icon(Icons.notes),
    //     onTap: () => addEditNote(context, document: notes),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       side: const BorderSide(color: Colors.grey),
    //     ),
    //   ),
    // );
  }
}

Future<void> addImage(QuillController controller, BuildContext context,
    {Document? document}) async {
  final isEditing = document != null;
  final quillEditorController = QuillController(
    document: document ?? Document(),
    selection: const TextSelection.collapsed(offset: 0),
  );

  // await showDialog(
  //   context: context,
  //   builder: (context) => AlertDialog(
  //     titlePadding: const EdgeInsets.only(left: 16, top: 8),
  //     title: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text('${isEditing ? 'Edit' : 'Add'} note'),
  //         IconButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           icon: const Icon(Icons.close),
  //         )
  //       ],
  //     ),
  //     content: QuillEditor.basic(
  //       controller: quillEditorController,
  //       configurations: const QuillEditorConfigurations(),
  //     ),
  //   ),
  // );

  // if (quillEditorController.document.isEmpty()) return;

  final block = BlockEmbed.custom(
    ImageBlockEmbed.fromDocument(quillEditorController.document),
  );
  final index = controller.selection.baseOffset;
  final length = controller.selection.extentOffset - index;

  if (isEditing) {
    final offset = getEmbedNode(controller, controller.selection.start).offset;
    controller.replaceText(
        offset, 1, block, TextSelection.collapsed(offset: offset));
  } else {
    controller.replaceText(index, length, block, null);
  }
}
