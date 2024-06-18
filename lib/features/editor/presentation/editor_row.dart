import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:learning_app/features/editor/presentation/text_field_controller.dart';

class EditorRow extends StatefulWidget {
  const EditorRow({super.key, required this.onFormatChanged});
  final VoidCallback onFormatChanged;
  @override
  State<EditorRow> createState() => _EditorRowState();
}

class _EditorRowState extends State<EditorRow> {
  Set<TextFormatType> textFormatSelection = <TextFormatType>{};
  LineFormatType lineFormatSelection = LineFormatType.body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SegmentedButton<TextFormatType>(
          // Define the segments
          segments: [
            ButtonSegment(
              value: TextFormatType.bold,
              label: Text('B'),
            ),
            ButtonSegment(
              value: TextFormatType.italic,
              label: Text('I'),
            ),
            ButtonSegment(
              value: TextFormatType.underlined,
              label: Text('U'),
            ),
          ],
          // Specify that multiple selections are allowed
          multiSelectionEnabled: true,
          emptySelectionAllowed: true,
          // Provide the initial selected values
          selected: textFormatSelection,
          // Handle the selection changes
          onSelectionChanged: (newSelection) {
            context.read<EditorCubit>().changeFormatting(newSelection);
            widget.onFormatChanged();
            setState(() {
              textFormatSelection = newSelection;
            });
          },
        ),
        SegmentedButton<LineFormatType>(
          // Define the segments
          segments: [
            ButtonSegment(
              value: LineFormatType.heading,
              label: Text('Heading'),
            ),
            ButtonSegment(
              value: LineFormatType.subheading,
              label: Text('Subheading'),
            ),
            ButtonSegment(
              value: LineFormatType.body,
              label: Text('Body'),
            ),
          ],
          // Specify that multiple selections are allowed
          multiSelectionEnabled: false,
          emptySelectionAllowed: false,
          // Provide the initial selected values
          selected: <LineFormatType>{lineFormatSelection},

          // Handle the selection changes
          onSelectionChanged: (newSelection) {
            // context.read<EditorCubit>().changeFormatting(newSelection);
            context.read<EditorCubit>().changeLineFormat(newSelection.first);
            widget.onFormatChanged();
            setState(() {
              lineFormatSelection = newSelection.first;
            });
          },
        ),
      ],
    );
  }
}
