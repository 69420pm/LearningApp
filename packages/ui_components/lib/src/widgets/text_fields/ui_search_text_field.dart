import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UISearchTextField extends StatelessWidget {
  UISearchTextField(
      {super.key,
      required this.onChanged,
      required this.hintText,
      this.onCard = false,
      this.suffixIconPressed});

  void Function(String) onChanged;
  String hintText;
  bool onCard;
  void Function()? suffixIconPressed;

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final focusNode = FocusNode();
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: onCard ? UIColors.onOverlayCard : UIColors.overlay,
        borderRadius:
            const BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              focusNode: focusNode,
              controller: searchController,
              cursorColor: UIColors.smallText,
              style: UIText.labelBold,
              autofocus: true,
              onChanged: onChanged,
              decoration: InputDecoration(
                isDense: true,
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                prefixIcon: UIIconButton(
                  icon: UIIcons.arrowBack
                      .copyWith(size: 30, color: UIColors.smallText),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                suffixIcon: UIIconButton(
                  icon: UIIcons.cancel
                      .copyWith(size: 24, color: UIColors.smallText),
                  onPressed: () {
                    searchController.clear();
                    focusNode.requestFocus();
                    suffixIconPressed?.call();
                  },
                ),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
