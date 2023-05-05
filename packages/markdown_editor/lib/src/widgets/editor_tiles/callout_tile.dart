import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/helper/menu_bottom_sheet.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';
import 'package:ui_components/ui_components.dart';

class CalloutTile extends StatelessWidget implements EditorTile {
  CalloutTile({
    super.key,
    this.tileColor = Colors.white12,
    TextTile? textTile,
    this.iconString = '🤪',
  }) {
    this.textTile = textTile ??
        TextTile(
          focusNode: focusNode,
          textStyle: TextFieldConstants.normal,
          parentEditorTile: this,
        );
    textFieldController = this.textTile.textFieldController;
  }

  Color tileColor;
  String iconString;

  late final TextTile textTile;

  @override
  FocusNode? focusNode = FocusNode();

  @override
  TextFieldController? textFieldController;
  final TextEditingController _emojiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _emojiController.text = iconString;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            SizedBox(
              width: 25,
              child: GestureDetector(
                child: Text(
                  _emojiController.text,
                  style: TextFieldConstants.calloutStart,
                ),
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<TextEditorBloc>(),
                    child: UIEmojiPicker(
                      onEmojiClicked: (p0) {
                        _emojiController.text = p0.emoji;

                        final newTile = copyWith(iconString: p0.emoji);
                        context
                            .read<TextEditorBloc>()
                            .add(TextEditorReplaceEditorTile(
                              tileToRemove: this,
                              newEditorTile: newTile,
                              context: context,
                              requestFocus: false,
                            ),);

                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
              // TextField(
              //   controller: _emojiController,
              //   style: TextFieldConstants.calloutStart,
              //   maxLength: 1,
              //   decoration: const InputDecoration(
              //       isDense: true,
              //       counterStyle: TextStyle(
              //         height: double.minPositive,
              //       ),
              //       counterText: '',
              //       border: InputBorder.none),
              // ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(child: textTile),
            IconButton(
              icon: const Icon(Icons.more_vert),
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

  CalloutTile copyWith(
      {Color? tileColor, TextTile? textTile, String? iconString,}) {
    return CalloutTile(
      tileColor: tileColor ?? this.tileColor,
      textTile: textTile ?? this.textTile,
      iconString: iconString ?? this.iconString,
    );
  }

  @override
  List<Object?> get props => [textTile, focusNode];

  @override
  bool? get stringify => false;

  @override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalloutTile &&
          runtimeType == other.runtimeType &&
          textTile == other.textTile &&
          focusNode == other.focusNode;
}
