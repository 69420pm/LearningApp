import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';
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
  Set<FormatType> selection = <FormatType>{};
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
          SegmentedButton<FormatType>(
            // Define the segments
            segments: [
              ButtonSegment(
                value: FormatType.bold,
                label: Text('B'),
              ),
              ButtonSegment(
                value: FormatType.italic,
                label: Text('I'),
              ),
              ButtonSegment(
                value: FormatType.underlined,
                label: Text('U'),
              ),
            ],
            // Specify that multiple selections are allowed
            multiSelectionEnabled: true,
            emptySelectionAllowed: true,
            // Provide the initial selected values
            selected: selection,
            // Handle the selection changes
            onSelectionChanged: (newSelection) {
              context.read<EditorCubit>().changeFormatting(newSelection);
              setState(() {
                selection = newSelection;
              });
            },
          ),
        ],
      ),
    );
  }
}
