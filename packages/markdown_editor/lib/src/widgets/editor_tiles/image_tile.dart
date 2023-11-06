import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/bottom_sheets/image_bottom_sheet.dart';
import 'package:markdown_editor/src/widgets/image_widgets/image_full_screen.dart';
import 'package:ui_components/ui_components.dart';

class ImageTile extends StatefulWidget implements EditorTile {
  /// constructor focusNode gets focusNode of widget and [image] is a File
  /// that gets displayed
  ImageTile({
    super.key,
    required this.image,
    this.scale = 1,
    this.alignment = Alignment.center,
  }) {
    // dismiss keyboard
    // FocusManager.instance.primaryFocus?.unfocus();
  }

  /// image that gets displayed
  File image;

  /// scale of the image how it should get displayed
  double scale;

  /// whether the image should get centered or left bound
  Alignment alignment;

  @override
  FocusNode? focusNode;

  FocusNode noFocus = FocusNode();

  @override
  State<ImageTile> createState() => _ImageTileState();

  @override
  TextFieldController? textFieldController;

  /// copy with method
  ImageTile copyWith({File? image, double? scale, Alignment? alignment}) {
    return ImageTile(
      image: image ?? this.image,
      scale: scale ?? this.scale,
      alignment: alignment ?? this.alignment,
    );
  }

  double scaleToHandleScale(double scale) {
    return pow(scale + 0.1, 0.2) - 0.00899;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageTile &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          alignment == other.alignment &&
          focusNode == other.focusNode;
}

class _ImageTileState extends State<ImageTile> {
  bool selected = false;

  @override
  void initState() {
    FocusManager.instance.addListener(focusChanged);
    super.initState();
  }

  void focusChanged() {
    if (selected && FocusManager.instance.primaryFocus! != widget.noFocus) {
      setState(() {
        selected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final handleScale = widget.scaleToHandleScale(widget.scale);

    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
        if (selected) {
                   FocusScope.of(context).requestFocus(widget.noFocus);

        }
        // print(selected);
      },
      onDoubleTap: (){
        showDialog(
                context: context,
                builder: (_) => ImageFullScreen(image: widget.image),
                barrierDismissible: true,
              );
      },
      child: Stack(
        children: [
          Container(
            alignment: widget.alignment,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth -
                    (2 * UIConstants.pageHorizontalPadding);
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: UIConstants.pageHorizontalPadding,
                        right: UIConstants.pageHorizontalPadding,
                        bottom: 17,
                      ),
                      child: SizedBox(
                        width: maxWidth * widget.scale,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            color: UIColors.focused,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                UIConstants.cornerRadiusSmall,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(selected ? 4 : 0),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  UIConstants.cornerRadiusSmall - 6,
                                ),
                              ),
                              child: Image.file(
                                widget.image,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // three dot menu
                    Visibility(
                      visible: selected,
                      child: Positioned(
                        top: 6,
                        right: UIConstants.pageHorizontalPadding + 6,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    UIConstants.cornerRadius,
                                  ),
                                  color: UIColors.smallTextLight,
                                ),
                              ),
                            ),
                            UIIconButton(
                              icon: UIIcons.moreHoriz
                                  .copyWith(color: UIColors.smallTextDark),
                              onPressed: () => UIBottomSheet.showUIBottomSheet(
                                context: context,
                                builder: (context) => BlocProvider.value(
                                  value: this.context.read<TextEditorBloc>(),
                                  child: ImageBottomSheet(
                                    parentEditorTile: widget,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // drag handle
                    Visibility(
                      visible: selected,
                      child: Positioned(
                        bottom: 0,
                        right: UIConstants.pageHorizontalPadding - 17,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onVerticalDragUpdate: (details) {
                            var newScale = widget.scale;
                            newScale += details.delta.dy / maxWidth;
                            if (newScale < 0.3) {
                              newScale = 0.3;
                            } else if (newScale > 1) {
                              newScale = 1;
                            }
                            setState(() {
                              widget.scale = newScale;
                            });
                          },
                          onHorizontalDragUpdate: (details) {
                            var newScale = widget.scale;
                            newScale += details.delta.dx / maxWidth;
                            if (newScale < 0.3) {
                              newScale = 0.3;
                            } else if (newScale > 1) {
                              newScale = 1;
                            }
                            setState(() {
                              widget.scale = newScale;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10 / handleScale),
                            child: Container(
                              width: 24 * handleScale,
                              height: 24 * handleScale,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  UIConstants.cornerRadius,
                                ),
                                color: UIColors.focused,
                              ),
                              child: Container(
                                width: 16 * handleScale,
                                height: 16 * handleScale,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    UIConstants.cornerRadius,
                                  ),
                                  color: UIColors.overlay,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(focusChanged);
    super.dispose();
  }
}
