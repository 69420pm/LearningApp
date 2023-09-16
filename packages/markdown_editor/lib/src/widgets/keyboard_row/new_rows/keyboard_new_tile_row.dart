import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/divider_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/header_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/list_editor_tile.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_button.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_toggle.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardNewTileRow extends StatelessWidget {
  const KeyboardNewTileRow({super.key});

  @override
  Widget build(BuildContext context) {
    final textEditorBloc = context.read<TextEditorBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  KeyboardRowContainer(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Row(
                        children: [
                          KeyboardButton(
                            icon: UIIcons.bigTitle,
                            onPressed: () {
                              context.read<KeyboardRowCubit>().addNewTile(
                                    HeaderTile(
                                      textStyle: UIText.titleBig,
                                      hintText: 'Heading big',
                                    ),
                                    textEditorBloc,
                                    context,
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              KeyboardButton(
                icon: UIIcons.cancel,
                onPressed: () {
                  context.read<KeyboardRowCubit>().expandText();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      KeyboardRowContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              KeyboardButton(
                                icon: UIIcons.bigTitle,
                                onPressed: () {
                                  context.read<KeyboardRowCubit>().addNewTile(
                                        HeaderTile(
                                          textStyle: UIText.titleBig,
                                          hintText: 'Heading big',
                                        ),
                                        textEditorBloc,
                                        context,
                                      );
                                },
                              ),
                              KeyboardButton(
                                icon: UIIcons.smallTitle,
                                onPressed: () {
                                  context.read<KeyboardRowCubit>().addNewTile(
                                        HeaderTile(
                                          textStyle: UIText.labelBold,
                                          hintText: 'Heading small',
                                        ),
                                        textEditorBloc,
                                        context,
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      KeyboardRowContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              KeyboardButton(
                                icon: UIIcons.horizontalRule,
                                onPressed: () {
                                  context.read<KeyboardRowCubit>().addNewTile(
                                        DividerTile(),
                                        textEditorBloc,
                                        context,
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      KeyboardRowContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              KeyboardButton(
                                icon: UIIcons.formatListBulleted,
                                onPressed: () {
                                  context.read<KeyboardRowCubit>().addNewTile(
                                        ListEditorTile(),
                                        textEditorBloc,
                                        context,
                                      );
                                },
                              ),
                              KeyboardButton(
                                icon: UIIcons.formatListNumbered,
                                onPressed: () {
                                  context.read<KeyboardRowCubit>().addNewTile(
                                        ListEditorTile(
                                          orderNumber: 1,
                                        ),
                                        textEditorBloc,
                                        context,
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              KeyboardButton(
                icon: UIIcons.done.copyWith(color: UIColors.primary),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
