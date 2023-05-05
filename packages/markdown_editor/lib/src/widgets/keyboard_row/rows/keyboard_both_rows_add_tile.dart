import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/callout_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/divider_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/header_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/image_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/list_editor_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/quote_tile.dart';
import 'package:ui_components/src/ui_constants.dart';

class KeyboardBothRowsAddTile extends StatelessWidget {
  const KeyboardBothRowsAddTile({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      IconButton(
        icon: const Icon(Icons.title),
        onPressed: () => context.read<TextEditorBloc>().add(
              TextEditorAddEditorTile(
                newEditorTile: HeaderTile(
                  textStyle: TextFieldConstants.header1,
                  hintText: 'Header 1',
                ),
                context: context,
              ),
            ),
      ),
      IconButton(
        icon: const Icon(Icons.title),
        onPressed: () => context.read<TextEditorBloc>().add(
              TextEditorAddEditorTile(
                newEditorTile: HeaderTile(
                  textStyle: TextFieldConstants.header2,
                  hintText: 'Header 2',
                ),
                context: context,
              ),
            ),
      ),
      IconButton(
        icon: const Icon(Icons.title),
        onPressed: () => context.read<TextEditorBloc>().add(
              TextEditorAddEditorTile(
                newEditorTile: HeaderTile(
                  textStyle: TextFieldConstants.header3,
                  hintText: 'Header 3',
                ),
                context: context,
              ),
            ),
      ),
      IconButton(
        icon: const Icon(Icons.crop_16_9),
        onPressed: () => context.read<TextEditorBloc>().add(
              TextEditorAddEditorTile(
                newEditorTile: CalloutTile(),
                context: context,
              ),
            ),
      ),
      IconButton(
        icon: const Icon(Icons.format_list_bulleted),
        onPressed: () => context.read<TextEditorBloc>().add(
              TextEditorAddEditorTile(
                newEditorTile: ListEditorTile(),
                context: context,
              ),
            ),
      ),
      IconButton(
        icon: const Icon(Icons.format_list_numbered),
        onPressed: () => context.read<TextEditorBloc>().add(
              TextEditorAddEditorTile(
                newEditorTile: ListEditorTile(orderNumber: 1),
                context: context,
              ),
            ),
      ),
      const IconButton(
        icon: Icon(Icons.functions),
        onPressed: null,
      ),
      IconButton(
        icon: const Icon(Icons.image),
        onPressed: () => context.read<TextEditorBloc>().add(
            TextEditorAddEditorTile(
                newEditorTile: ImageTile(), context: context,),),
      ),
      const IconButton(
        icon: Icon(Icons.audio_file),
        onPressed: null,
      ),
      IconButton(
        icon: const Icon(Icons.format_quote),
        onPressed: () => context.read<TextEditorBloc>().add(
              TextEditorAddEditorTile(
                newEditorTile: QuoteTile(),
                context: context,
              ),
            ),
      ),
      IconButton(
        icon: const Icon(Icons.horizontal_rule),
        onPressed: () => context.read<TextEditorBloc>().add(
              TextEditorAddEditorTile(
                newEditorTile: DividerTile(),
                context: context,
              ),
            ),
      ),
      const IconButton(
        icon: Icon(Icons.table_chart),
        onPressed: null,
      ),
    ];

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.read<KeyboardRowCubit>().expandFavorites(),
        ),
        Expanded(
          child: GridView.extent(
            shrinkWrap: true,
            primary: true,
            crossAxisSpacing: UIConstants.defaultSize,
            mainAxisSpacing: UIConstants.defaultSize,
            maxCrossAxisExtent: UIConstants.defaultSize * 8,
            children: tiles,
          ),
        )
      ],
    );
  }
}
