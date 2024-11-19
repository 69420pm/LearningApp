import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:learning_app/features/editor/presentation/editor_input_formatter.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field_controller.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field_manager.dart';

class TextTile extends StatelessWidget {
  const TextTile({super.key});

  @override
  Widget build(BuildContext context) {
    // EditorTextFieldManager editorTextFieldManager = EditorTextFieldManager();
    // double cursorHeight = 16;
    // EditorInputFormatter inputFormatter =
    //     EditorInputFormatter(em: editorTextFieldManager, co);
    // EditorTextFieldController editorTextFieldController =
    //     EditorTextFieldController(
    //   em: editorTextFieldManager,
    //   inputFormatter: inputFormatter,
    // );
    // context.read<EditorCubit>().inputFormatter = inputFormatter;
    // return TextField(
    //   inputFormatters: [inputFormatter],
    //   keyboardType: TextInputType.multiline,
    //   maxLines: null,
    //   controller: editorTextFieldController,
    //   cursorHeight: cursorHeight,
    // );
    return Text('TextTile');
  }
}
