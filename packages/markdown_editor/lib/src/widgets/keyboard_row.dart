import 'package:flutter/material.dart';
import 'package:markdown_editor/src/bloc/text_editor_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/widgets/keyboard_expandable.dart';
import 'package:markdown_editor/src/widgets/keyboard_toggle.dart';

class KeyboardRow extends StatelessWidget {
  KeyboardRow({super.key});

  List<bool> _selections = List.generate(7, (index) => false);

  bool isBold = false;
  bool isItalic = false;
  bool isUnderlined = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KeyboardToggle(
              icon: const Icon(Icons.format_bold),
              onPressed: () {
                isBold = !isBold;
                context.read<TextEditorBloc>().add(
                      TextEditorKeyboardRowChange(
                        isBold: isBold,
                        isItalic: isItalic,
                        isUnderlined: isUnderlined,
                      ),
                    );
              },
            ),
            KeyboardToggle(
              icon: const Icon(Icons.format_italic),
              onPressed: () {
                isItalic = !isItalic;
                context.read<TextEditorBloc>().add(
                      TextEditorKeyboardRowChange(
                        isBold: isBold,
                        isItalic: isItalic,
                        isUnderlined: isUnderlined,
                      ),
                    );
              },
            ),
            KeyboardToggle(
              icon: const Icon(Icons.format_underline),
              onPressed: () {
                isUnderlined = !isUnderlined;
                context.read<TextEditorBloc>().add(
                      TextEditorKeyboardRowChange(
                        isBold: isBold,
                        isItalic: isItalic,
                        isUnderlined: isUnderlined,
                      ),
                    );
              },
            ),
            KeyboardToggle(
              icon: const Icon(Icons.format_color_text),
              onPressed: () {
                isBold = !isBold;
                context.read<TextEditorBloc>().add(
                      TextEditorKeyboardRowChange(
                        isBold: isBold,
                        isItalic: isItalic,
                        isUnderlined: isUnderlined,
                      ),
                    );
              },
            ),
            KeyboardExpandable(icon: Icon(Icons.functions))
          ],
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
