import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/ui_components/ui_colors.dart';

class DropZones extends StatefulWidget {
  DropZones({super.key, required this.index});
  int index;
  @override
  State<DropZones> createState() => _DropZonesState();
}

class _DropZonesState extends State<DropZones> {
  Color color = Colors.transparent;
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onMove: (data) {
        setState(() {
          color = UIColors.blueTransparent;
        });
      },
      onLeave: (data) {
        setState(() {
          color = Colors.transparent;
        });
      },
      onAccept: (data) {
        context.read<TextEditorBloc>().add(TextEditorChangeOrderOfTile(
            oldIndex: data as int, newIndex: widget.index + 1))
            ;
            setState(() {
          color = Colors.transparent;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(height: 10, width: 1000, color: color);
      },
    );
  }
}
