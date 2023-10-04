import 'package:flutter/material.dart';
import 'package:ui_components/src/ui_text.dart';
import 'package:ui_components/src/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:ui_components/ui_components.dart';

class UISelectionBottomSheet extends StatelessWidget {
  UISelectionBottomSheet(
      {super.key, required this.selectionText, required this.selection});

  List<String> selectionText;
  void Function(int selection) selection;

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: selectionText.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              selection.call(index);
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text(
                  selectionText[index],
                  style: UIText.label,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
