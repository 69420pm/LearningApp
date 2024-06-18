import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:learning_app/features/editor/presentation/editor_row.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field.dart';
import 'package:learning_app/features/editor/presentation/text_field_controller.dart';
import 'package:learning_app/features/editor/presentation/text_formatter.dart';
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

class _EditorView extends StatefulWidget {
  _EditorView({super.key});

  @override
  State<_EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<_EditorView> {
  TextFieldController controller = TextFieldController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: controller,
            inputFormatters: [TextFormatter()],
          ),
          Expanded(child: Container()),
          EditorRow(
            onFormatChanged: () {
              setState(() {});
            },
          )
        ],
      ),
    );
  }
}
