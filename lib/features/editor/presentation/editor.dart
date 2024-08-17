// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:learning_app/features/editor/presentation/editor_controller.dart';
import 'package:learning_app/features/editor/presentation/editor_input_formatter.dart';
import 'package:learning_app/features/editor/presentation/editor_row.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field_manager.dart';
import 'package:learning_app/features/editor/presentation/helper/editor_text_styles.dart';
import 'package:learning_app/features/editor/presentation/text_field_controller.dart';
import 'package:learning_app/injection_container.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EditorCubit>(),
      child: _EditorView(),
    );
  }
}

class _EditorView extends StatelessWidget {
  EditorTextFieldManager editorTextFieldManager = EditorTextFieldManager();
  double cursorHeight = 16;
  TextFieldController controller = TextFieldController();

  EditorTextStyle style = EditorTextStyle();
  @override
  Widget build(BuildContext context) {
    EditorInputFormatter inputFormatter =
        EditorInputFormatter(em: editorTextFieldManager);
    EditorController editorController = EditorController(
      editorTextFieldManager: editorTextFieldManager,
    );
    context.read<EditorCubit>().inputFormatter = inputFormatter;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          BlocBuilder<EditorCubit, EditorState>(
            builder: (context, state) {
              switch (context.read<EditorCubit>().currentLineFormat) {
                case LineFormatType.heading:
                  cursorHeight = 26;
                  break;
                case LineFormatType.subheading:
                  cursorHeight = 20;
                default:
                  cursorHeight = 16;
                  break;
              }

              return TextField(
                inputFormatters: [inputFormatter],
                keyboardType: TextInputType.multiline,
                maxLines: null,
                // controller: editorController,
                cursorHeight: cursorHeight,
                onChanged: (value) {
                  print('update onChanged');
                },
              );
            },
          ),
          Expanded(child: Container()),
          EditorRow()
        ],
      ),
    );
  }
}

class DeleteCharacterAction extends Action<DeleteCharacterIntent> {
  @override
  void invoke(DeleteCharacterIntent intent) {
    print('deletion');
  }
}

class PasteTextIntentAction extends Action<PasteTextIntent> {
  @override
  void invoke(PasteTextIntent intent) {
    print('paste');
  }
}
