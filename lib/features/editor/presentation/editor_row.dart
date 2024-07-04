import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:learning_app/features/editor/presentation/text_field_controller.dart';

class EditorRow extends StatelessWidget {
  LineFormatType lineFormatSelection = LineFormatType.body;

  EditorRow({super.key});

  @override
  Widget build(BuildContext context) {
    Set<TextFormatType> textFormatSelection = <TextFormatType>{};

    return Column(
      children: [
        BlocBuilder<EditorCubit, EditorState>(
          buildWhen: (previous, current) =>
              current is EditorTextFormattingChanged,
          builder: (context, state) {
            if (state is EditorTextFormattingChanged) {
              textFormatSelection = state.textFormatSelection;
            }
            return SegmentedButton<TextFormatType>(
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
              },
            );
          },
        ),
        BlocBuilder<EditorCubit, EditorState>(
          buildWhen: (previous, current) =>
              current is EditorLineFormattingChanged,
          builder: (context, state) {
            if (state is EditorLineFormattingChanged) {
              lineFormatSelection = state.lineFormatType;
            }
            return SegmentedButton<LineFormatType>(
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
                context
                    .read<EditorCubit>()
                    .changeLineFormat(newSelection.first);
              },
            );
          },
        ),
      ],
    );
  }
}
