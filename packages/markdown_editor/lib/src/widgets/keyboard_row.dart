import 'package:flutter/material.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/widgets/keyboard_row_element.dart';

class KeyboardRow extends StatefulWidget {
  const KeyboardRow({super.key});

  @override
  State<KeyboardRow> createState() => _KeyboardRowState();
}

class _KeyboardRowState extends State<KeyboardRow> {
  List<bool> _selections = List.generate(7, (index) => false);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [KeyboardToggle(icon: const Icon(Icons.format_bold))],
        )
        // Row(
        //   children: [
        //     ToggleButtons(
        //       renderBorder: false,
        //       isSelected: _selections,
        //       onPressed: (index) {
        //         setState(() {
        //           _selections[index] = !_selections[index];
        //         });
        //         context.read<TextEditorBloc>().add(
        //               TextEditorKeyboardRowChange(
        //                 isBold: _selections[0],
        //                 isItalic: _selections[1],
        //                 isUnderlined: _selections[2],
        //               ),
        //             );
        //       },
        //       children: const [
        //         Icon(Icons.format_bold),
        //         Icon(Icons.format_italic),
        //         Icon(Icons.format_underline),
        //         Icon(Icons.format_color_text),
        //         Icon(Icons.functions),
        //         Icon(Icons.format_list_bulleted),
        //         Icon(Icons.format_list_numbered),
        //       ],
        //     ),
        //     VerticalDivider(thickness: 3, color: Colors.blue),
        //     KeyboardRowElement()
        //   ],
        // ),
        // Row(
        //   children: [
        //     ToggleButtons(
        //       renderBorder: false,
        //       isSelected: _selections,
        //       onPressed: (index) {
        //         setState(() {
        //           _selections[index] = !_selections[index];
        //         });
        //         context.read<TextEditorBloc>().add(
        //               TextEditorKeyboardRowChange(
        //                 isBold: _selections[0],
        //                 isItalic: _selections[1],
        //                 isUnderlined: _selections[2],
        //               ),
        //             );
        //       },
        //       children: const [
        //         Icon(Icons.format_bold),
        //         Icon(Icons.format_italic),
        //         Icon(Icons.format_underline),
        //         Icon(Icons.format_color_text),
        //         Icon(Icons.functions),
        //         Icon(Icons.format_list_bulleted),
        //         Icon(Icons.format_list_numbered),
        //       ],
        //     ),
        //     VerticalDivider(thickness: 3, color: Colors.blue),
        //     KeyboardRowElement()
        //   ],
        // ),
      ],
    );
  }
}

class KeyboardToggle extends StatelessWidget {
  KeyboardToggle({super.key, required this.icon});
  Icon icon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {},
    style: ButtonStyle(), child: icon);
  }
}
