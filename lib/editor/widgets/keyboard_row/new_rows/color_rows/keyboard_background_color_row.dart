import 'package:flutter/material.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/cubit/keyboard_row_cubit.dart';
import 'package:learning_app/editor/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:learning_app/editor/widgets/keyboard_row/new_rows/color_rows/color_selectors.dart';
import 'package:learning_app/editor/widgets/keyboard_row/new_rows/keyboard_text_row.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardBackgroundColorRow extends StatefulWidget {
  const KeyboardBackgroundColorRow({super.key});

  @override
  State<KeyboardBackgroundColorRow> createState() =>
      _KeyboardBackgroundColorRowState();
}

class _KeyboardBackgroundColorRowState
    extends State<KeyboardBackgroundColorRow> {
  @override
  Widget build(BuildContext context) {
    final textEditorBloc = context.read<TextEditorBloc>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        KeyboardRowContainer(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _DefaultBackgroundColorSelector(),
              ColorSelector(
                color: UIColors.red,
                onPressed: () => context
                    .read<KeyboardRowCubit>()
                    .changeBackgroundColor(UIColors.redTransparent, textEditorBloc),
              ),
              ColorSelector(
                color: UIColors.yellow,
                onPressed: () => context
                    .read<KeyboardRowCubit>()
                    .changeBackgroundColor(UIColors.yellowTransparent, textEditorBloc),
              ),
              ColorSelector(
                color: UIColors.green,
                onPressed: () => context
                    .read<KeyboardRowCubit>()
                    .changeBackgroundColor(UIColors.greenTransparent, textEditorBloc),
              ),
              ColorSelector(
                color: UIColors.blue,
                onPressed: () => context
                    .read<KeyboardRowCubit>()
                    .changeBackgroundColor(UIColors.blueTransparent, textEditorBloc),
              ),
              ColorSelector(
                color: UIColors.purple,
                onPressed: () => context
                    .read<KeyboardRowCubit>()
                    .changeBackgroundColor(UIColors.purpleTransparent, textEditorBloc),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        KeyboardTextRow(isBold: textEditorBloc.isBold,
          isItalic: textEditorBloc.isItalic,
          isUnderlined: textEditorBloc.isUnderlined,
          textColor: textEditorBloc.textColor,
          backgroundColor: textEditorBloc.textBackgroundColor,),
      ],
    );
  }
}

class _DefaultBackgroundColorSelector extends StatelessWidget {
  const _DefaultBackgroundColorSelector();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<KeyboardRowCubit>().changeBackgroundColor(
            Colors.transparent, context.read<TextEditorBloc>(),);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
                        mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: const BoxDecoration(
                      color: UIColors.smallText,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(UIConstants.cornerRadius),
                      ),),
                ),
                Container(
                  height: 12,
                  width: 12,
                  decoration: const BoxDecoration(
                      color: UIColors.onOverlayCard,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(UIConstants.cornerRadius),
                          ),),
                ),
              ],
            ),
             Row(
                        mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: const BoxDecoration(
                      color: UIColors.onOverlayCard,
                      borderRadius: BorderRadius.only(
                          
                          bottomLeft: Radius.circular(UIConstants.cornerRadius),),),
                ),
                Container(
                  height: 12,
                  width: 12,
                  decoration: const BoxDecoration(
                      color: UIColors.smallText,
                      borderRadius: BorderRadius.only(
                          
                          bottomRight: Radius.circular(UIConstants.cornerRadius),),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
