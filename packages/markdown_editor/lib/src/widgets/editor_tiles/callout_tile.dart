import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/helper/menu_bottom_sheet.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/helper/three_dot_menu.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalloutTile extends StatelessWidget implements EditorTile {
  CalloutTile({super.key, this.tileColor = Colors.white12, this.textTile}) {
    _textTile = textTile ?? TextTile(
      focusNode: focusNode,
      textStyle: TextFieldConstants.normal,
      parentEditorTile: this,
    );
    focusNode = _textTile.focusNode;
  }

  Color tileColor;
  TextTile? textTile;

  late final TextTile _textTile;

  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;
  final TextEditingController _emojiController =
      TextEditingController(text: '🤪');

  @override
  Widget build(BuildContext context) {
    textFieldController = _textTile.textFieldController;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            SizedBox(
              width: 25,
              child: TextField(
                controller: _emojiController,
                style: TextFieldConstants.calloutStart,
                maxLength: 1,
                decoration: const InputDecoration(
                    isDense: true,
                    counterStyle: TextStyle(
                      height: double.minPositive,
                    ),
                    counterText: '',
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(child: _textTile),
            ThreeDotMenu(
              onPressed: () => showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<TextEditorBloc>(),
                  child: MenuBottomSheet(
                    parentEditorTile: this,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  CalloutTile copyWith({Color? tileColor, TextTile? textTile}) {
    return CalloutTile(
      tileColor: tileColor ?? this.tileColor,
      textTile: textTile ?? _textTile,
    );
  }

  @override
  List<Object?> get props => [_textTile, focusNode];

  @override
  bool? get stringify => false;
}
