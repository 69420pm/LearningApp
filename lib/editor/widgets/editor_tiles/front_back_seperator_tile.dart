import 'package:flutter/material.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/models/text_field_controller.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FrontBackSeparatorTile extends StatelessWidget implements EditorTile {
  FrontBackSeparatorTile({
    super.key,
    this.inRenderMode = false,
  });

  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;

  @override
  bool inRenderMode;

  @override
  Widget build(BuildContext context) {
    //not shown in renderMode
    if (inRenderMode) return const SizedBox();
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
}
