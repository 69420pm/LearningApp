import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class AddCardSettingsBottomSheet extends StatelessWidget {
  const AddCardSettingsBottomSheet({super.key});

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
              UISwitch(
                startValue: true,
                onChanged: (value) {},
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
              UISwitch(
                startValue: true,
                onChanged: (value) {},
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
