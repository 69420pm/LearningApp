import 'package:flutter/material.dart';
import 'dart:io';

import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:image_picker/image_picker.dart';

class ImageTile extends StatelessWidget implements EditorTile {
  ImageTile({super.key, this.focusNode}) {
    focusNode = focusNode ?? FocusNode();
  }
  File? _image;
  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: getImage, child: const Text('fd')),
        if (_image != null)
          Image.file(
            _image!,
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          )
        else
          Text("fd"),
      ],
    );
  }

  Future<dynamic> getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    _image = File(image.path);
  }
}
