import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_latex_row.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_math_fork/ast.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_math_fork/tex.dart';

class LatexBottomSheet extends StatefulWidget {
  LatexBottomSheet({
    super.key,
    required this.textEditingController,
    required this.latexText,
  });

  TextEditingController textEditingController;
  String latexText;

  @override
  State<LatexBottomSheet> createState() => _LatexBottomSheetState();
}

class _LatexBottomSheetState extends State<LatexBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height:  100,
              width: 300,
              // TODO scrollbar not visible
              child: Scrollbar(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:[ Math.tex(
                    widget.latexText,
                    mathStyle: MathStyle.display,
                    textStyle: TextStyle(fontSize: 25),
                    onErrorFallback: (err) => Container(
                      color: Colors.red,
                      child: Text(
                        err.messageWithType,
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                  ),]
                ),
              ),
            ),
          ),
          SizedBox(
            height: UIConstants.defaultSize,
          ),
          UITextFormField(
            initialValue: widget.latexText,
            autofocus: true,
            controller: widget.textEditingController,
            validation: (text) {
              return null;
            },
            onFieldSubmitted: (_) => Navigator.pop(context),
            onChanged: (text) {
              setState(() {
                widget.latexText = text;
              });
            },
          ),
          KeyboardLatexRow(
            textEditingController: widget.textEditingController,
          ),
        ],
      ),
    );
  }
}
