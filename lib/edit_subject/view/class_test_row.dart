import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui_components/ui_components.dart';

class ClassTestColumn extends StatelessWidget {
  const ClassTestColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
        color: UIColors.overlay,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.cardVerticalPadding,
          vertical: UIConstants.cardVerticalPadding / 2,
        ),
        child: Column(
          children: [
            ClassTestListTile(
              classTest: ClassTest(
                date: DateTime.now().toIso8601String(),
                id: "fd",
                name: "fd",
                folderIds: [],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ClassTestListTile extends StatelessWidget {
  ClassTestListTile({super.key, required this.classTest});
  ClassTest classTest;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        Navigator.of(context).pushNamed('/subject_overview/edit_subject/add_class_test', arguments: classTest);
      },
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.itemPadding / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                UIIcons.classTest.copyWith(size: UIConstants.iconSizeSmall),
                const SizedBox(
                  width: UIConstants.itemPadding / 1.6,
                ),
                Text(classTest.name, style: UIText.label),
              ],
            ),
            Row(
              children: [
                Text(
                  DateFormat('MM/dd').format(DateTime.parse(classTest.date)),
                  style: UIText.label,
                ),
                const SizedBox(
                  width: UIConstants.itemPadding * 0.5,
                ),
                UIIcons.arrowForwardNormal
                    .copyWith(size: UIConstants.iconSizeSmall, color: UIColors.smallText),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
