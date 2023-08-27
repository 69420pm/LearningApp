import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui_components/ui_components.dart';

class AddClassTestPage extends StatelessWidget {
  AddClassTestPage({super.key, required this.classTest}) {
    addClassTest = classTest == null;
    if (!addClassTest) {
      nameController.text = classTest!.name;
    }
  }

  ClassTest? classTest;
  bool addClassTest = true;
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return UIPage(
      appBar: UIAppBar(
        leading: UIIconButton(
          icon: UIIcons.arrowBack,
          onPressed: () {},
        ),
        title: addClassTest ? 'Add Class Test' : 'Edit Class Test',
      ),
      body: Column(children: [
        Row(
          children: [
            Container(
                height: 48,
                width: 48,
                alignment: Alignment.center,
                child: UIIcons.classTest.copyWith(color: UIColors.smallText)),
            const SizedBox(
              width: UIConstants.itemPadding * 0.75,
            ),
            Expanded(
              child: UITextFieldLarge(
                controller: nameController,
                onChanged: (p0) {},
              ),
            ),
          ],
        ),
        const SizedBox(
          height: UIConstants.itemPaddingLarge,
        ),
        UIContainer(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Date', style: UIText.label),
            if (addClassTest)
              Row(
                children: [
                  Text('Add Date',
                      style: UIText.label.copyWith(color: UIColors.primary)),
                  const SizedBox(
                    width: UIConstants.itemPadding * 0.5,
                  ),
                  UIIcons.add.copyWith(color: UIColors.primary, size: 26),
                ],
              )
            else
              Row(
                children: [
                  Text(
                    DateFormat('MM/dd').format(DateTime.parse(classTest!.date)),
                    style: UIText.label,
                  ),
                  const SizedBox(
                    width: UIConstants.itemPadding * 0.5,
                  ),
                  UIIcons.arrowForwardSmall.copyWith(color: UIColors.smallText),
                ],
              ),
          ],
        ))
      ]),
    );
  }
}
