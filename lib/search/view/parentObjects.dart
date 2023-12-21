import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class ParentObjects extends StatelessWidget {
  ParentObjects({super.key, required this.parentObjects}) {
    var i = 0;
    for (final element in parentObjects) {
      pathViewElements.add(
        _PathViewElement(
          title: (element is Folder)
              ? element.name
              : (element as Subject).name,
          icon: i == 0
              //TODO add below custom subject icon to display
              ? UIIcons.placeHolder.copyWith(
                  size: UIConstants.iconSizeSmall,
                  color: UIColors.smallText,
                )
              : UIIcons.folder.copyWith(
                  size: UIConstants.iconSizeSmall,
                  color: UIColors.smallText,
                ),
        ),
      );
      if (i < parentObjects.length - 1) {
        pathViewElements
          ..add(Text('->',
              style: UIText.normalBold.copyWith(color: UIColors.smallText),),)
          ..add(
            const SizedBox(
              width: UIConstants.itemPadding / 4,
            ),
          );
      }
      i++;
    }
  }
  List<Object> parentObjects;
  List<Widget> pathViewElements = [];
  @override
  Widget build(BuildContext context) {
    return Row(
      children: pathViewElements,
    );
  }
}

class _PathViewElement extends StatelessWidget {
  _PathViewElement({required this.title, required this.icon});
  String title;
  Widget icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: UIConstants.itemPadding / 4,
        ),
        Text(
          title,
          style: UIText.normalBold.copyWith(color: UIColors.smallText),
        ),
        const SizedBox(
          width: UIConstants.itemPadding / 4,
        ),
      ],
    );
  }
}