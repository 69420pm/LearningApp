import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class CardSettingsPage extends StatelessWidget {
  CardSettingsPage(
      {super.key,
      required this.card,
      required this.parentId,
      required this.editorTiles});
  Card card;
  String? parentId;
  List<EditorTile> editorTiles;
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (card.name.isEmpty) {
      nameController.text =
          context.read<AddCardCubit>().getCardName(editorTiles);
    } else {
      nameController.text = card.name;
    }
    return UIPage(
      appBar: const UIAppBar(
        leadingBackButton: true,
        title: 'Card Settings',
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UITextFieldLarge(
            controller: nameController,
            onChanged: (p0) {
              if (p0 == null || p0.isEmpty) return;
              card.name = p0;
              context.read<AddCardCubit>().saveCard(card, parentId, null);
            },
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Both Directions', style: UIText.label),
              BlocBuilder<AddCardCubit, AddCardState>(
                builder: (context, state) {
                  return UISwitch(
                    startValue: card.askCardsInverted,
                    onChanged: (value) {
                      card.askCardsInverted = value;
                      context
                          .read<AddCardCubit>()
                          .saveCard(card, parentId, null);
                    },
                  );
                },
              ),
            ],
          ),
          UIDescription(
            text:
                'Enhance your learning: Try guessing with sides randomly swapped, similar to flipping vocabulary cards',
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Type Answer', style: UIText.label),
              BlocBuilder<AddCardCubit, AddCardState>(
                builder: (context, state) {
                  return UISwitch(
                    startValue: card.typeAnswer,
                    onChanged: (value) {
                      card.typeAnswer = value;
                      context
                          .read<AddCardCubit>()
                          .saveCard(card, parentId, null);
                    },
                  );
                },
              ),
            ],
          ),
          UIDescription(
            text:
                'For vocabulary learning, type translations using the keyboard to improve spelling',
          ),
          // const SizedBox(
          //   height: UIConstants.itemPaddingLarge,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text('Suggested Title', style: UIText.label),
          //     UIIconButton(
          //       onPressed: () {

          //       },
          //       alignment: Alignment.centerRight,
          //       icon: UIIcons.arrowForwardSmall
          //           .copyWith(color: UIColors.smallText),
          //       text: card.name,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
