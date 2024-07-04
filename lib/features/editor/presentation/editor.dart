import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:learning_app/features/editor/presentation/editor_row.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field.dart';
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
  double cursorHeight = 16;
  TextFieldController controller = TextFieldController();

  @override
  Widget build(BuildContext context) {
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
                default:
                  cursorHeight = 16;
                  break;
              }
              return TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: controller,
                cursorHeight: cursorHeight,
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
