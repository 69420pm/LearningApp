import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FrontBackSeparatorTile extends StatelessWidget implements EditorTile {
  FrontBackSeparatorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: UIConstants.pageHorizontalPadding,
          child: GestureDetector(onTap: () {
            context
                .read<TextEditorBloc>()
                .add(TextEditorAddWidgetAboveSeparator(context: context));
          }),
        ),
        const Divider(
          color: UIColors.smallTextDark,
          thickness: 5,
        ),
        SizedBox(
          height: UIConstants.pageHorizontalPadding,
          child: GestureDetector(
            onTap: () {
              context
                  .read<TextEditorBloc>()
                  .add(TextEditorFocusWidgetAfterSeparator());
            },
          ),
        ),
      ],
    );
  }

  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;
}
