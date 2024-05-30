import 'package:flutter/material.dart';
import 'package:learning_app/features/editor/text_field_controller.dart';

class Editor extends StatefulWidget {
  Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  TextFieldController controller = TextFieldController();
  List<bool> selection = List.generate(3, (index) => false);
  String _selectedValue = 'Option 1';
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
          ),
          SegmentedButton<String>(
            segments: const <ButtonSegment<String>>[
              ButtonSegment<String>(
                value: 'Option 1',
                label: Text('Option 1'),
                icon: Icon(Icons.looks_one),
              ),
              ButtonSegment<String>(
                value: 'Option 2',
                label: Text('Option 2'),
                icon: Icon(Icons.looks_two),
              ),
              ButtonSegment<String>(
                value: 'Option 3',
                label: Text('Option 3'),
                icon: Icon(Icons.looks_3),
              ),
            ],
            selected: <String>{_selectedValue},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedValue = newSelection.first;
              });
            },
          ),
        ],
      ),
    );
  }
}
