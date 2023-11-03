import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:ui_components/ui_components.dart';

class AddCardSettingsBottomSheet extends StatelessWidget {
  AddCardSettingsBottomSheet(
      {super.key, required this.card, required this.parentId});
  Card card;
  String? parentId;
  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      title: const Text('Card Settings', style: UIText.label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Suggested Title', style: UIText.label),
              UIIconButton(
                onPressed: () {},
                alignment: Alignment.centerRight,
                icon: UIIcons.arrowForwardSmall
                    .copyWith(color: UIColors.smallText),
                text: 'add title here',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
