import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/helper/image_helper.dart';
import 'package:learning_app/editor/widgets/editor_tiles/image_tile.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class AddImageBottomSheet extends StatelessWidget {
  const AddImageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      title: const Text(
        'Import Image',
        style: UIText.label,
      ),
      child: Column(
        children: [
          UIIconRow(
            icon: UIIcons.camera,
            text: 'From Camera',
            onPressed: () async {
              final image = await ImageHelper.pickImageCamera();
              if (image != null) {
                if(context.mounted){
context.read<TextEditorBloc>().add(
                      TextEditorAddEditorTile(
                        newEditorTile: ImageTile(image: image),
                        context: context,
                      ),
                    );
                }
                
              }
              if(context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          UIIconRow(
            icon: UIIcons.photoLibrary,
            text: 'From Gallery',
            onPressed: () async {
              final image = await ImageHelper.pickImageGallery();
              if (image != null) {
                if(context.mounted){
context.read<TextEditorBloc>().add(
                      TextEditorAddEditorTile(
                        newEditorTile: ImageTile(image: image),
                        context: context,
                      ),
                    );
                }
                
              }
              if(context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
