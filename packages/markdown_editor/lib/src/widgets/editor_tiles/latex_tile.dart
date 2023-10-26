import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/latex_text_field_controller.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/bottom_sheets/latex_bottom_sheet.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_components/ui_components.dart';

class LatexTile extends StatefulWidget implements EditorTile, Equatable {
  LatexTile({super.key, this.latexText = r""});

  String latexText;
  @override
  FocusNode? focusNode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatexTile &&
          runtimeType == other.runtimeType &&
          latexText == other.latexText &&
          focusNode == other.focusNode;

  @override
  List<Object?> get props => [latexText, focusNode];

  @override
  bool? get stringify => false;

  @override
  TextFieldController? textFieldController;

  TextEditingController textEditingController = LatexTextFieldController();
  @override
  State<LatexTile> createState() => _LatexTileState();

  /// copy with function of CalloutTile
  LatexTile copyWith({
    String? latexText,
  }) {
    return LatexTile(
      latexText: latexText ?? this.latexText,
    );
  }
}

class _LatexTileState extends State<LatexTile> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // @override
  // void initState() {
  //   super.initState();
  //   if (_scaffoldKey.currentState == null ) {
  //     {
  //       WidgetsBinding.instance
  //           .addPostFrameCallback((_) => showLatexBottomSheet());
  //     }
  //   }
  // }

  void showLatexBottomSheet() {
    UIBottomSheet.showUIBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          BlocProvider.value(
            value: context.read<TextEditorBloc>(),
            child: LatexBottomSheet(
              textEditingController: widget.textEditingController,
              latexText: widget.latexText,
              focusNode: widget.focusNode ??= FocusNode(),
              onChanged: (text) => setState(
                () {
                  widget.latexText = text;
                },
              ),
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      if (widget.latexText.isNotEmpty) {
        context.read<TextEditorBloc>().add(
              TextEditorReplaceEditorTile(
                tileToRemove: widget,
                newEditorTile:
                    widget.copyWith(latexText: widget.textEditingController.text),
                context: context,
              ),
            );
      } else {
        context.read<TextEditorBloc>().add(
              TextEditorRemoveEditorTile(
                tileToRemove: widget,
                context: context,
              ),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.pageHorizontalPadding, vertical: UIConstants.itemPadding),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: showLatexBottomSheet,
        child: Math.tex(
          widget.latexText,
          textStyle: TextStyle(
            fontSize: 25,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onErrorFallback: (err) => Container(
            color: Colors.red,
            child: Text(
              err.messageWithType,
              style: TextStyle(color: Colors.yellow),
            ),
          ),
        ),
      ),
    ); // Default
  }
}
