import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/bottom_sheets/image_menu_bottom_sheet.dart';

class ImageTile extends StatefulWidget implements EditorTile {
  /// constructor focusNode gets focusNode of widget and [image] is a File
  /// that gets displayed
  ImageTile({super.key, required this.image}) {
    // dismiss keyboard
    // FocusManager.instance.primaryFocus?.unfocus();
  }

  /// image that gets displayed
  File image;

  @override
  FocusNode? focusNode;

  @override
  State<ImageTile> createState() => _ImageTileState();

  @override
  TextFieldController? textFieldController;

  /// copy with method
  ImageTile copyWith({File? image}) {
    return ImageTile(
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

class _ImageTileState extends State<ImageTile> {
  double _scale = 1;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            SizedBox(
              width: constraints.maxWidth * _scale,
              child: Center(
                child: Image.file(
                  widget.image,
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              // bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.3,
                      height: constraints.maxHeight,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _scale -= details.delta.dx * 0.01;
                            _scale = _scale.clamp(0.3, 1.0);
                          });
                        },
                      ),
                    ),
                    Positioned.fill(
                      left: 16,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IgnorePointer(
                          child: Container(
                            width: 6,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(140, 255, 255, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              // bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.3,
                      height: constraints.maxHeight,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _scale += details.delta.dx * 0.01;
                            _scale = _scale.clamp(0.3, 1.0);
                          });
                        },
                      ),
                    ),
                    Positioned.fill(
                      right: 16,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IgnorePointer(
                          child: Container(
                            width: 6,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(140, 255, 255, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                      parentEditorTile: widget,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
