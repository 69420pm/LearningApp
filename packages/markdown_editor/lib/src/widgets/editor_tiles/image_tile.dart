import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/helper/image_menu_bottom_sheet.dart';

class ImageTile extends StatelessWidget implements EditorTile {
  ImageTile({super.key, this.focusNode, this.image}) {
    focusNode = focusNode ?? FocusNode();
    // dismiss keyboard
    FocusManager.instance.primaryFocus?.unfocus();

  }
  File? image;
  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (image != null)
          Stack(
            children: [
              Image.file(
                image!,
                // width: 250,
                // height: 250,
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<TextEditorBloc>(),
                    child: ImageMenuBottomSheet(
                      parentEditorTile: this,
                    ),
                  ),
                ),
                          ),
              )
            ],
          )
        else
          _EmptyImage(
            image: image,
            context: context,
            parentTile: this,
          )
      ],
    );
  }

  /// copy with method
  ImageTile copyWith({FocusNode? focusNode, File? image}) {
    return ImageTile(
      focusNode: focusNode ?? this.focusNode,
      image: image ?? this.image,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageTile &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          focusNode == other.focusNode;
}

class _EmptyImage extends StatelessWidget {
  _EmptyImage({
    required this.image,
    required this.context,
    required this.parentTile,
  });
  File? image;
  BuildContext context;
  ImageTile parentTile;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        children: [
          const Text('add image'),
          Row(
            children: [
              ElevatedButton(
                  onPressed: pickImageGallery, child: const Text('gallery'),),
              ElevatedButton(onPressed: pickImageCamera, child: const Text('camera'))
            ],
          )
        ],
      ),
    );
  }

  Future<void> pickImageGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    image = File(pickedImage.path);
    context.read<TextEditorBloc>().add(
          TextEditorReplaceEditorTile(
            tileToRemove: parentTile,
            newEditorTile: parentTile.copyWith(image: image),
            context: context,
          ),
        );
  }

  Future<void> pickImageCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) return;
    image = File(pickedImage.path);
    context.read<TextEditorBloc>().add(
          TextEditorReplaceEditorTile(
            tileToRemove: parentTile,
            newEditorTile: parentTile.copyWith(image: image),
            context: context,
          ),
        );
  }
}
