import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/read_only_interactable.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LinkTile extends StatelessWidget
    implements EditorTile, ReadOnlyInteractable {
  LinkTile({super.key, required this.cardId, this.interactable = true});
  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;

  String cardId;

  @override
  Widget build(BuildContext context) {
    final card =
        context.read<TextEditorBloc>().cardsRepository.getCardById(cardId);
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          UIBottomSheet.showUIBottomSheet(
            context: context,
            builder: (_) {
              return CardPreviewBottomSheet(
                card: card,
                cardsRepository: context.read<TextEditorBloc>().cardsRepository,
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: UIConstants.itemPadding / 2,
            horizontal: UIConstants.pageHorizontalPadding,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: UIColors.overlay,
              borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: UIConstants.itemPadding,
                right: 2,
                // top: UIConstants.itemPadding / 2.5,
                /* bottom: UIConstants.itemPadding/2.5 */
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UIIcons.link.copyWith(color: UIColors.smallText),
                  const SizedBox(width: UIConstants.itemPadding / 2),
                  Text(
                    card!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: UIText.label.copyWith(color: UIColors.smallText),
                  ),
                  UIIconButton(
                    icon: UIIcons.cancel
                        .copyWith(color: UIColors.background, size: 28),
                    animateToWhite: true,
                    onPressed: () {
                      if (!interactable) return;
                      context.read<TextEditorBloc>().add(
                            TextEditorRemoveEditorTile(
                              tileToRemove: this,
                              context: context,
                            ),
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool interactable;
}
