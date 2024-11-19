import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/helper/image_helper.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/cubit/editor_bloc.dart';
import 'package:learning_app/features/quill_editor/presentation/editor_keyboard_row/cubit/editor_keyboard_row_cubit.dart';
import 'package:learning_app/features/quill_editor/presentation/image_embed_block.dart';
import 'package:learning_app/injection_container.dart';

class ImageButton extends StatelessWidget {
  ImageButton({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await (await sl<ImageHelper>().pickImageFromGallery()).match((failure) {
          print(failure.errorMessage);
        }, (image) async {
          final croppedImage = await sl<ImageHelper>().cropImage(image: image);
          croppedImage.match((failure) {}, (filePath) {
            addImage(
              context.read<EditorKeyboardRowCubit>().controller,
              context,
            );
            context.read<EditorBloc>().imagePath = filePath;
          });
        });
      },
      icon: const Icon(Icons.photo_camera_outlined),
    );
  }
}
