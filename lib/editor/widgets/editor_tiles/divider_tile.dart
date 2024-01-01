import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/models/text_field_controller.dart';
import 'package:learning_app/editor/widgets/bottom_sheets/divider_bottom_sheet.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';

class DividerTile extends StatelessWidget implements EditorTile {
  DividerTile({
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        UIBottomSheet.showUIBottomSheet(
          context: context,
          builder: (_) => BlocProvider.value(
            value: context.read<TextEditorBloc>(),
            child: DividerBottomSheet(parentTile: this),
          ),
        );
      },
      child: const Padding(
        padding:
            EdgeInsets.symmetric(horizontal: UIConstants.pageHorizontalPadding),
        child: Divider(
          color: UIColors.smallTextDark,
          thickness: 2,
        ),
      ),
    );
  }
}
