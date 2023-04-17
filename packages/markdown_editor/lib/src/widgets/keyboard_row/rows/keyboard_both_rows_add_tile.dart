import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/callout_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/divider_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/header_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/list_editor_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/quote_tile.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_expandable.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_selectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardBothRowsAddTile extends StatelessWidget {
  const KeyboardBothRowsAddTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        KeyboardExpandable(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.read<KeyboardRowCubit>().expandFavorites(),
          height: 80,
        ),
        Column(
          children: [
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _KeyboardAddNewTileTile(
                    icon: const Icon(Icons.title),
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorAddEditorTile(
                              newEditorTile: HeaderTile(
                                textStyle: TextFieldConstants.header1,
                                hintText: 'Header 1',
                              ),
                              context: context),
                        ),
                  ),
                  _KeyboardAddNewTileTile(
                    icon: const Icon(Icons.title),
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorAddEditorTile(
                              newEditorTile: HeaderTile(
                                textStyle: TextFieldConstants.header2,
                                hintText: 'Header 2',
                              ),
                              context: context),
                        ),
                  ),
                  _KeyboardAddNewTileTile(
                    icon: const Icon(Icons.title),
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorAddEditorTile(
                              newEditorTile: HeaderTile(
                                textStyle: TextFieldConstants.header3,
                                hintText: 'Header 3',
                              ),
                              context: context),
                        ),
                  ),
                  _KeyboardAddNewTileTile(
                    icon: const Icon(Icons.crop_16_9),
                    onPressed: () => context.read<TextEditorBloc>().add(
                        TextEditorAddEditorTile(
                            newEditorTile: CalloutTile(), context: context)),
                  ),
                  _KeyboardAddNewTileTile(
                    icon: const Icon(Icons.format_list_bulleted),
                    onPressed: () => context.read<TextEditorBloc>().add(
                        TextEditorAddEditorTile(
                            newEditorTile: ListEditorTile(), context: context)),
                  ),
                  _KeyboardAddNewTileTile(
                    icon: const Icon(Icons.question_mark),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _KeyboardAddNewTileTile(icon: const Icon(Icons.functions)),
                  _KeyboardAddNewTileTile(icon: const Icon(Icons.image)),
                  _KeyboardAddNewTileTile(icon: const Icon(Icons.audio_file)),
                  _KeyboardAddNewTileTile(
                    icon: const Icon(Icons.format_quote),
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorAddEditorTile(
                              newEditorTile: QuoteTile(), context: context),
                        ),
                  ),
                  _KeyboardAddNewTileTile(
                    icon: const Icon(Icons.horizontal_rule),
                    onPressed: () => context.read<TextEditorBloc>().add(
                          TextEditorAddEditorTile(
                              newEditorTile: DividerTile(), context: context),
                        ),
                  ),
                  _KeyboardAddNewTileTile(
                    icon: const Icon(Icons.format_quote),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _KeyboardAddNewTileTile extends StatelessWidget {
  _KeyboardAddNewTileTile({super.key, required this.icon, this.onPressed});

  Icon icon;
  Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return KeyboardExpandable(
      onPressed: onPressed,
      icon: icon,
      width: 60,
    );
  }
}
